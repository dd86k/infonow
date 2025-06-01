module main;

import std.stdio;
import gpu.amdgpu;

void main(string[] args)
{
    // NOTE: avoiding getopt saves a slight overhead
    try foreach (string arg; args[1..$])
    {
        switch (arg) {
        case "%gpuload":
            stdout.write(amdgpu_gpu_usage_percent());
            break;
        case "%gpumem":
            stdout.write(amdgpu_mem_usage_percent());
            break;
        case "%gputemp":
            stdout.write(amdgpu_gpu_temp());
            break;
        case "%gpumemtemp":
            stdout.write(amdgpu_gpu_mem_temp());
            break;
        default:
            stdout.write(arg);
        }
    }
    catch (Exception ex)
    {
        stdout.write("error");
        // I think WlxOverlay only reads up to a line (or EOF)
        // So this might be safe
        stdout.writeln();
        stdout.writeln(ex);
    }
    stdout.flush();
}
