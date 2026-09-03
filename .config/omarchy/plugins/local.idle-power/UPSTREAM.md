# Idle Power

Cloned from `omarchy.idle`.

Source: `/usr/share/omarchy/shell/plugins/services/idle`

This local service owns configurable screensaver, monitor power-off, and
suspend deadlines. It intentionally omits idle locking, so `omarchy.idle`
remains disabled while this replacement service is active. At monitor-off it
stops the screensaver like Omarchy's lock transition, while preserving the
suspend deadline and using a dedicated activity monitor to wake the displays.
