module main;

import cpu;
import gpu.amdgpu;
import std.stdio;

// These options shave off 0m0,001s startup time! #Epic

// Disable GC DRT options
extern(C) __gshared bool rt_cmdline_enabled = false;
// Disable environment variables for DRT
extern(C) __gshared bool rt_envvars_enabled = false;
// Disable GC at startup
extern(C) __gshared string[] rt_options = [ "gcopt=disable:1"];

void main(string[] args)
{
    if (args.length <= 1)
    {
        writeln("Built ", __TIMESTAMP__);
        writeln("Available:");
        writeln(" %gpuload");
        writeln(" %gpumem");
        writeln(" %gputemp");
        writeln(" %gpumemtemp");
        writeln(" %cpu");
        return;
    }
    
    // NOTE: avoiding getopt saves a slight overhead
    try foreach (string arg; args[1..$])
    {
        switch (arg) {
        case "%gpuload":    stdout.write(amdgpu_gpu_usage_percent()); break;
        case "%gpumem":     stdout.write(amdgpu_mem_usage_percent()); break;
        case "%gputemp":    stdout.write(amdgpu_gpu_temp()); break;
        case "%gpumemtemp": stdout.write(amdgpu_gpu_mem_temp()); break;
        case "%cpu":        stdout.writef("%.2f", cpu_usage()); break;
        default:            stdout.write(arg);
        }
    }
    catch (Exception ex)
    {
        stderr.write("error");
        // I think WlxOverlay only reads up to a line (or EOF)
        // So this might be safe for testing purposes
        stderr.writeln();
        stderr.writeln(ex);
    }
    stdout.flush();
}
