import os
import shlex
import shutil

from gi import require_version

require_version("Nautilus", "4.1")

from gi.repository import GObject, Gio, Nautilus


SUPPORTED_EXTENSIONS = {
    ".csv",
    ".doc",
    ".docm",
    ".docx",
    ".odp",
    ".ods",
    ".odt",
    ".ppt",
    ".pptm",
    ".pptx",
    ".rtf",
    ".txt",
    ".xls",
    ".xlsm",
    ".xlsx",
}


class ConvertToPdfAction(GObject.GObject, Nautilus.MenuProvider):
    def _launch_conversion(self, path):
        wrapper = shutil.which("omarchy-launch-floating-terminal-with-presentation")
        libreoffice = shutil.which("libreoffice") or shutil.which("soffice")
        if not wrapper or not libreoffice:
            return

        directory = os.path.dirname(path)
        stem = os.path.splitext(os.path.basename(path))[0]
        target = os.path.join(directory, f"{stem}.pdf")

        script = f"""
set -e
source={shlex.quote(path)}
stem={shlex.quote(stem)}
target={shlex.quote(target)}
tmpdir=$(mktemp -d)
profile=$(mktemp -d)
cleanup() {{
  rm -rf "$tmpdir" "$profile"
}}
trap cleanup EXIT

echo {shlex.quote(f"Converting {path} to PDF")}
{shlex.join([libreoffice])} --headless --nologo --nofirststartwizard \
  -env:UserInstallation=file://"$profile" \
  --convert-to pdf --outdir "$tmpdir" "$source"

output="$tmpdir/$stem.pdf"
if [[ ! -f "$output" ]]; then
  output=$(find "$tmpdir" -maxdepth 1 -type f -iname '*.pdf' -print -quit)
fi

if [[ -z "$output" || ! -f "$output" ]]; then
  echo "No PDF was created."
  exit 1
fi

mv -f "$output" "$target"
echo "Wrote $target"
"""

        Gio.Subprocess.new([wrapper, script], Gio.SubprocessFlags.NONE)

    def _is_supported(self, file):
        if file.is_directory():
            return False

        location = file.get_location()
        if not location:
            return False

        path = location.get_path() or ""
        return os.path.splitext(path.lower())[1] in SUPPORTED_EXTENSIONS

    def _selected_path(self, files):
        if len(files) != 1:
            return None

        file = files[0]
        if not self._is_supported(file):
            return None

        location = file.get_location()
        if not location:
            return None

        return location.get_path()

    def _make_item(self, path):
        item = Nautilus.MenuItem(
            name="ConvertToPdfNautilus::convert_to_pdf",
            label="Convert to PDF",
            icon="application-pdf",
        )
        item.connect("activate", self._on_activate, path)
        return item

    def _on_activate(self, _menu, path):
        self._launch_conversion(path)

    def _tools_available(self):
        return bool(
            shutil.which("omarchy-launch-floating-terminal-with-presentation")
            and (shutil.which("libreoffice") or shutil.which("soffice"))
        )

    def get_file_items(self, *args):
        files = args[0] if len(args) == 1 else args[1]
        if not self._tools_available():
            return []

        path = self._selected_path(files)
        if not path:
            return []

        return [self._make_item(path)]
