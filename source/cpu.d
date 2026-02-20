module cpu;

private
struct CPUStats
{
    ulong user;
    ulong nice;
    ulong system;
    ulong idle;
    ulong iowait;
    ulong irq;
    ulong softirq;
    ulong steal;
}

private
CPUStats read_cpu_stats()
{
    import std.stdio : File;
    import std.format : formattedRead;
    
    File fp = File("/proc/stat", "r");
    
    string line = fp.readln();
    
    CPUStats stats;
    
    string b = void; // for "cpu"
    uint r = void;
    with (stats)
    r = formattedRead(line, "%s %d %d %d %d %d %d %d %d",
        b,
        user,
        nice,
        system,
        idle,
        iowait,
        irq,
        softirq,
        steal);
    assert(r == 9);
    
    return stats;
}

double cpu_usage()
{
    import core.thread : Thread;
    import std.datetime : Duration, dur;
    
    CPUStats a = read_cpu_stats();
    
    Thread.sleep(dur!"msecs"(100));
    
    CPUStats b = read_cpu_stats();
    
    ulong a_idle = a.idle + a.iowait;
    ulong b_idle = b.idle + b.iowait;
    
    ulong a_total = a.user + a.nice + a.system + 
                    a.idle + a.iowait + a.irq + 
                    a.softirq + a.steal;
    ulong b_total = b.user + b.nice + b.system + 
                    b.idle + b.iowait + b.irq + 
                    b.softirq + b.steal;
    
    ulong total_diff    = b_total - a_total;
    ulong idle_diff     = b_idle - a_idle;
    
    if (total_diff == 0)
        return 0.0;
    
    return 100.0 * (total_diff - idle_diff) / total_diff;
}
