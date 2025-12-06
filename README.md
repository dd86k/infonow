Quick and dirty tool to get some system information on Linux.

Notes:
- Currently only works with amdgpu. Where it is `card1` (in sysfs).
- Only `gpu_metrics` 1.3 was tested.
- Hacky project. Highly recommended to check values directly first before regular use.

Usage: infonow VARIABLE...

Example: `infonow %gpuload % usage, %gpumem " " %mem` prints `5% usage, 12% mem` without any newlines.

VARIABLE:
- `%gpuload`: GPU load percentage (gfx) via `gpu_busy_percent`.
- `%gpumem`: GPU VRAM usage percentage via `mem_info_vram_used` and `mem_info_vram_total`.
- `%gputemp`: GPU edge temperature via `gpu_metrics`.
- `%gpumemtemp`: GPU memory temperature via `gpu_metrics`.
- `%cpu`: Global CPU load via `/proc/stat`.
- default: Writes text as-is. This helps concatenate text.
