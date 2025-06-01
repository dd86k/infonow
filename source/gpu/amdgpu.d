module gpu.amdgpu;

import std.stdio;

uint amdgpu_gpu_usage_percent()
{
    import std.conv : to;
    import std.string : stripRight;
    File file;
    file.open("/sys/class/drm/card1/device/gpu_busy_percent");
    return to!uint( stripRight( file.readln() ) );
}

uint amdgpu_mem_usage_percent()
{
    File file_used;
    file_used.open("/sys/class/drm/card1/device/mem_info_vram_used");
    File file_total;
    file_total.open("/sys/class/drm/card1/device/mem_info_vram_total");
    
    import std.conv : to;
    import std.string : stripRight;
    
    string str_vram_used = stripRight( file_used.readln() );
    string str_vram_total = stripRight( file_total.readln() );
    
    // Tested against Mission Center 1.0.2
    return
        cast(uint)(
        to!double(str_vram_used) / 
        to!double(str_vram_total)
        * 100.0);
}

uint amdgpu_gpu_temp()
{
    AMDGPU_Metrics metric = amdgpu_get_metrics();
    
    return metric.temp;
}

uint amdgpu_gpu_mem_temp()
{
    AMDGPU_Metrics metric = amdgpu_get_metrics();
    
    return metric.memtemp;
}

private:

struct AMDGPU_Metrics
{
    uint temp;
    uint memtemp;
}

AMDGPU_Metrics amdgpu_get_metrics()
{
    File file;
    file.open("/sys/class/drm/card1/device/gpu_metrics");
    
    union gpu_metrics
    {
        align(1):
        metrics_table_header table;
        gpu_metrics_v1_0 v1_0;
        gpu_metrics_v1_1 v1_1;
        gpu_metrics_v1_2 v1_2;
        gpu_metrics_v1_3 v1_3;
        gpu_metrics_v1_4 v1_4;
        gpu_metrics_v1_5 v1_5;
        gpu_metrics_v1_6 v1_6;
        gpu_metrics_v1_7 v1_7;
        gpu_metrics_v1_8 v1_8;
        gpu_metrics_v2_0 v2_0;
        gpu_metrics_v2_1 v2_1;
        gpu_metrics_v2_2 v2_2;
        gpu_metrics_v2_3 v2_3;
        gpu_metrics_v2_4 v2_4;
        gpu_metrics_v3_0 v3_0;
        ubyte[512] buffer;
    }
    gpu_metrics metrics;
    size_t readsize = file.rawRead(metrics.buffer).length;
    
    AMDGPU_Metrics r;
    switch (metrics.table.format_revision) {
    case 1:
        switch (metrics.table.content_revision) {
        case 0: // 1.0
            if (metrics.table.structure_size != gpu_metrics_v1_0.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v1_0.sizeof");
            if (readsize != gpu_metrics_v1_0.sizeof)
                throw new Exception("size != gpu_metrics_v1_0.sizeof");
            
            r.temp = metrics.v1_0.temperature_edge;
            r.memtemp = metrics.v1_0.temperature_mem;
            break;
        case 1: // 1.1
            if (metrics.table.structure_size != gpu_metrics_v1_1.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v1_1.sizeof");
            if (readsize != gpu_metrics_v1_1.sizeof)
                throw new Exception("size != gpu_metrics_v1_1.sizeof");
            
            r.temp = metrics.v1_1.temperature_edge;
            r.memtemp = metrics.v1_1.temperature_mem;
            break;
        case 2: // 1.2
            if (metrics.table.structure_size != gpu_metrics_v1_2.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v1_2.sizeof");
            if (readsize != gpu_metrics_v1_2.sizeof)
                throw new Exception("size != gpu_metrics_v1_2.sizeof");
            
            r.temp = metrics.v1_2.temperature_edge;
            r.memtemp = metrics.v1_2.temperature_mem;
            break;
        case 3: // 1.3
            if (metrics.table.structure_size != gpu_metrics_v1_3.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v1_3.sizeof");
            if (readsize != gpu_metrics_v1_3.sizeof)
                throw new Exception("size != gpu_metrics_v1_3.sizeof");
            
            // Tested against Mission Center 1.0.2
            r.temp = metrics.v1_3.temperature_edge;
            r.memtemp = metrics.v1_3.temperature_mem;
            break;
        case 4: // 1.4
            if (metrics.table.structure_size != gpu_metrics_v1_4.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v1_4.sizeof");
            if (readsize != gpu_metrics_v1_4.sizeof)
                throw new Exception("size != gpu_metrics_v1_4.sizeof");
            
            r.temp = metrics.v1_4.temperature_hotspot;
            r.memtemp = metrics.v1_4.temperature_mem;
            break;
        case 5: // 1.5
            if (metrics.table.structure_size != gpu_metrics_v1_5.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v1_5.sizeof");
            if (readsize != gpu_metrics_v1_5.sizeof)
                throw new Exception("size != gpu_metrics_v1_5.sizeof");
            
            r.temp = metrics.v1_5.temperature_hotspot;
            r.memtemp = metrics.v1_5.temperature_mem;
            break;
        case 6: // 1.6
            if (metrics.table.structure_size != gpu_metrics_v1_6.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v1_6.sizeof");
            if (readsize != gpu_metrics_v1_6.sizeof)
                throw new Exception("size != gpu_metrics_v1_6.sizeof");
            
            r.temp = metrics.v1_6.temperature_hotspot;
            r.memtemp = metrics.v1_6.temperature_mem;
            break;
        case 7: // 1.7
            if (metrics.table.structure_size != gpu_metrics_v1_7.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v1_7.sizeof");
            if (readsize != gpu_metrics_v1_7.sizeof)
                throw new Exception("size != gpu_metrics_v1_7.sizeof");
            
            r.temp = metrics.v1_7.temperature_hotspot;
            r.memtemp = metrics.v1_7.temperature_mem;
            break;
        case 8: // 1.8
            if (metrics.table.structure_size != gpu_metrics_v1_8.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v1_8.sizeof");
            if (readsize != gpu_metrics_v1_8.sizeof)
                throw new Exception("size != gpu_metrics_v1_8.sizeof");
            
            r.temp = metrics.v1_8.temperature_hotspot;
            r.memtemp = metrics.v1_8.temperature_mem;
            break;
        default:
            throw new Exception("Content revision not supported");
        }
        break;
    case 2:
        switch (metrics.table.content_revision) {
        case 0: // 2.0
            if (metrics.table.structure_size != gpu_metrics_v2_0.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v2_0.sizeof");
            if (readsize != gpu_metrics_v2_0.sizeof)
                throw new Exception("size != gpu_metrics_v2_0.sizeof");
            
            r.temp = metrics.v2_0.temperature_gfx;
            // TODO: Seems incorrect. Get it another way
            r.memtemp = metrics.v2_0.temperature_l3[0];
            break;
        case 1: // 2.1
            if (metrics.table.structure_size != gpu_metrics_v2_1.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v2_1.sizeof");
            if (readsize != gpu_metrics_v2_1.sizeof)
                throw new Exception("size != gpu_metrics_v2_1.sizeof");
            
            r.temp = metrics.v2_1.temperature_gfx;
            // TODO: Seems incorrect. Get it another way
            r.memtemp = metrics.v2_1.temperature_l3[0];
            break;
        case 2: // 2.2
            if (metrics.table.structure_size != gpu_metrics_v2_2.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v2_2.sizeof");
            if (readsize != gpu_metrics_v2_2.sizeof)
                throw new Exception("size != gpu_metrics_v2_2.sizeof");
            
            r.temp = metrics.v2_2.temperature_gfx;
            // TODO: Seems incorrect. Get it another way
            r.memtemp = metrics.v2_2.temperature_l3[0];
            break;
        case 3: // 2.3
            if (metrics.table.structure_size != gpu_metrics_v2_3.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v2_3.sizeof");
            if (readsize != gpu_metrics_v2_3.sizeof)
                throw new Exception("size != gpu_metrics_v2_3.sizeof");
            
            r.temp = metrics.v2_3.temperature_gfx;
            // TODO: Seems incorrect. Get it another way
            r.memtemp = metrics.v2_3.temperature_l3[0];
            break;
        case 4: // 2.4
            if (metrics.table.structure_size != gpu_metrics_v2_4.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v2_4.sizeof");
            if (readsize != gpu_metrics_v2_4.sizeof)
                throw new Exception("size != gpu_metrics_v2_4.sizeof");
            
            r.temp = metrics.v2_4.temperature_gfx;
            // TODO: Seems incorrect. Get it another way
            r.memtemp = metrics.v2_4.temperature_l3[0];
            break;
        default:
            throw new Exception("Content revision not supported");
        }
        break;
    case 3:
        switch (metrics.table.content_revision) {
        case 0: // 3.0
            if (metrics.table.structure_size != gpu_metrics_v3_0.sizeof)
                throw new Exception("metrics.table.structure_size != gpu_metrics_v3_0.sizeof");
            if (readsize != gpu_metrics_v3_0.sizeof)
                throw new Exception("size != gpu_metrics_v3_0.sizeof");
            
            r.temp = metrics.v3_0.temperature_gfx;
            // TODO: Seems super incorrect. Get it another way
            r.memtemp = metrics.v3_0.temperature_skin;
            break;
        default:
            throw new Exception("Content revision not supported");
        }
        break;
    default:
        throw new Exception("Format revision not supported");
    }
    return r;
}

// https://github.com/torvalds/linux/blob/master/drivers/gpu/drm/amd/include/kgd_pp_interface.h

enum smu_event_type
{
    SMU_EVENT_RESET_COMPLETE = 0,
}

struct amd_vce_state
{
    align(1):
    /* vce clocks */
    uint evclk;
    uint ecclk;
    /* gpu clocks */
    uint sclk;
    uint mclk;
    ubyte clk_idx;
    ubyte pstate;
}

enum amd_dpm_forced_level
{
    AMD_DPM_FORCED_LEVEL_AUTO = 0x1,
    AMD_DPM_FORCED_LEVEL_MANUAL = 0x2,
    AMD_DPM_FORCED_LEVEL_LOW = 0x4,
    AMD_DPM_FORCED_LEVEL_HIGH = 0x8,
    AMD_DPM_FORCED_LEVEL_PROFILE_STANDARD = 0x10,
    AMD_DPM_FORCED_LEVEL_PROFILE_MIN_SCLK = 0x20,
    AMD_DPM_FORCED_LEVEL_PROFILE_MIN_MCLK = 0x40,
    AMD_DPM_FORCED_LEVEL_PROFILE_PEAK = 0x80,
    AMD_DPM_FORCED_LEVEL_PROFILE_EXIT = 0x100,
    AMD_DPM_FORCED_LEVEL_PERF_DETERMINISM = 0x200,
}

enum amd_pm_state_type
{
    /* not used for dpm */
    POWER_STATE_TYPE_DEFAULT,
    POWER_STATE_TYPE_POWERSAVE,
    /* user selectable states */
    POWER_STATE_TYPE_BATTERY,
    POWER_STATE_TYPE_BALANCED,
    POWER_STATE_TYPE_PERFORMANCE,
    /* internal states */
    POWER_STATE_TYPE_INTERNAL_UVD,
    POWER_STATE_TYPE_INTERNAL_UVD_SD,
    POWER_STATE_TYPE_INTERNAL_UVD_HD,
    POWER_STATE_TYPE_INTERNAL_UVD_HD2,
    POWER_STATE_TYPE_INTERNAL_UVD_MVC,
    POWER_STATE_TYPE_INTERNAL_BOOT,
    POWER_STATE_TYPE_INTERNAL_THERMAL,
    POWER_STATE_TYPE_INTERNAL_ACPI,
    POWER_STATE_TYPE_INTERNAL_ULV,
    POWER_STATE_TYPE_INTERNAL_3DPERF,
}

struct amdgpu_xcp_metrics
{
    /* Utilization Instantaneous (%) */
    uint[MAX_XCC] gfx_busy_inst;
    ushort[NUM_JPEG_ENG] jpeg_busy;
    ushort[NUM_VCN] vcn_busy;
    /* Utilization Accumulated (%) */
    ulong[MAX_XCC] gfx_busy_acc;
}

struct amdgpu_xcp_metrics_v1_1
{
    /* Utilization Instantaneous (%) */
    uint[MAX_XCC] gfx_busy_inst;
    ushort[NUM_JPEG_ENG] jpeg_busy;
    ushort[NUM_VCN] vcn_busy;
    /* Utilization Accumulated (%) */
    ulong[MAX_XCC] gfx_busy_acc;
    /* Total App Clock Counter Accumulated */
    ulong[MAX_XCC] gfx_below_host_limit_acc;
}

struct amdgpu_xcp_metrics_v1_2 {
    /* Utilization Instantaneous (%) */
    uint[MAX_XCC] gfx_busy_inst;
    ushort[NUM_JPEG_ENG_V1] jpeg_busy;
    ushort[NUM_VCN] vcn_busy;
    /* Utilization Accumulated (%) */
    ulong[MAX_XCC] gfx_busy_acc;
    /* Total App Clock Counter Accumulated */
    ulong[MAX_XCC] gfx_below_host_limit_ppt_acc;
    ulong[MAX_XCC] gfx_below_host_limit_thm_acc;
    ulong[MAX_XCC] gfx_low_utilization_acc;
    ulong[MAX_XCC] gfx_below_host_limit_total_acc;
}

enum AMD_MAX_VCE_LEVELS = 6;

enum amd_vce_level
{
    AMD_VCE_LEVEL_AC_ALL = 0,     /* AC, All cases */
    AMD_VCE_LEVEL_DC_EE = 1,      /* DC, entropy encoding */
    AMD_VCE_LEVEL_DC_LL_LOW = 2,  /* DC, low latency queue, res <= 720 */
    AMD_VCE_LEVEL_DC_LL_HIGH = 3, /* DC, low latency queue, 1080 >= res > 720 */
    AMD_VCE_LEVEL_DC_GP_LOW = 4,  /* DC, general purpose queue, res <= 720 */
    AMD_VCE_LEVEL_DC_GP_HIGH = 5, /* DC, general purpose queue, 1080 >= res > 720 */
}

enum amd_fan_ctrl_mode
{
    AMD_FAN_CTRL_NONE = 0,
    AMD_FAN_CTRL_MANUAL = 1,
    AMD_FAN_CTRL_AUTO = 2,
}

enum pp_clock_type
{
    PP_SCLK,
    PP_MCLK,
    PP_PCIE,
    PP_SOCCLK,
    PP_FCLK,
    PP_DCEFCLK,
    PP_VCLK,
    PP_VCLK1,
    PP_DCLK,
    PP_DCLK1,
    OD_SCLK,
    OD_MCLK,
    OD_VDDC_CURVE,
    OD_RANGE,
    OD_VDDGFX_OFFSET,
    OD_CCLK,
    OD_FAN_CURVE,
    OD_ACOUSTIC_LIMIT,
    OD_ACOUSTIC_TARGET,
    OD_FAN_TARGET_TEMPERATURE,
    OD_FAN_MINIMUM_PWM,
    OD_FAN_ZERO_RPM_ENABLE,
    OD_FAN_ZERO_RPM_STOP_TEMP,
}

enum amd_pp_sensors
{
    AMDGPU_PP_SENSOR_GFX_SCLK = 0,
    AMDGPU_PP_SENSOR_CPU_CLK,
    AMDGPU_PP_SENSOR_VDDNB,
    AMDGPU_PP_SENSOR_VDDGFX,
    AMDGPU_PP_SENSOR_VDDBOARD,
    AMDGPU_PP_SENSOR_UVD_VCLK,
    AMDGPU_PP_SENSOR_UVD_DCLK,
    AMDGPU_PP_SENSOR_VCE_ECCLK,
    AMDGPU_PP_SENSOR_GPU_LOAD,
    AMDGPU_PP_SENSOR_MEM_LOAD,
    AMDGPU_PP_SENSOR_GFX_MCLK,
    AMDGPU_PP_SENSOR_GPU_TEMP,
    AMDGPU_PP_SENSOR_EDGE_TEMP = AMDGPU_PP_SENSOR_GPU_TEMP,
    AMDGPU_PP_SENSOR_HOTSPOT_TEMP,
    AMDGPU_PP_SENSOR_MEM_TEMP,
    AMDGPU_PP_SENSOR_VCE_POWER,
    AMDGPU_PP_SENSOR_UVD_POWER,
    AMDGPU_PP_SENSOR_GPU_AVG_POWER,
    AMDGPU_PP_SENSOR_GPU_INPUT_POWER,
    AMDGPU_PP_SENSOR_SS_APU_SHARE,
    AMDGPU_PP_SENSOR_SS_DGPU_SHARE,
    AMDGPU_PP_SENSOR_STABLE_PSTATE_SCLK,
    AMDGPU_PP_SENSOR_STABLE_PSTATE_MCLK,
    AMDGPU_PP_SENSOR_ENABLED_SMC_FEATURES_MASK,
    AMDGPU_PP_SENSOR_MIN_FAN_RPM,
    AMDGPU_PP_SENSOR_MAX_FAN_RPM,
    AMDGPU_PP_SENSOR_VCN_POWER_STATE,
    AMDGPU_PP_SENSOR_PEAK_PSTATE_SCLK,
    AMDGPU_PP_SENSOR_PEAK_PSTATE_MCLK,
    AMDGPU_PP_SENSOR_VCN_LOAD,
}

enum amd_pp_task
{
    AMD_PP_TASK_DISPLAY_CONFIG_CHANGE,
    AMD_PP_TASK_ENABLE_USER_STATE,
    AMD_PP_TASK_READJUST_POWER_STATE,
    AMD_PP_TASK_COMPLETE_INIT,
    AMD_PP_TASK_MAX
}

enum PP_SMC_POWER_PROFILE
{
    PP_SMC_POWER_PROFILE_UNKNOWN = -1,
    PP_SMC_POWER_PROFILE_BOOTUP_DEFAULT = 0x0,
    PP_SMC_POWER_PROFILE_FULLSCREEN3D = 0x1,
    PP_SMC_POWER_PROFILE_POWERSAVING  = 0x2,
    PP_SMC_POWER_PROFILE_VIDEO        = 0x3,
    PP_SMC_POWER_PROFILE_VR           = 0x4,
    PP_SMC_POWER_PROFILE_COMPUTE      = 0x5,
    PP_SMC_POWER_PROFILE_CUSTOM       = 0x6,
    PP_SMC_POWER_PROFILE_WINDOW3D     = 0x7,
    PP_SMC_POWER_PROFILE_CAPPED	  = 0x8,
    PP_SMC_POWER_PROFILE_UNCAPPED	  = 0x9,
    PP_SMC_POWER_PROFILE_COUNT,
}

enum
{
    PP_GROUP_UNKNOWN = 0,
    PP_GROUP_GFX = 1,
    PP_GROUP_SYS,
    PP_GROUP_MAX
}

enum PP_OD_DPM_TABLE_COMMAND
{
    PP_OD_EDIT_SCLK_VDDC_TABLE,
    PP_OD_EDIT_MCLK_VDDC_TABLE,
    PP_OD_EDIT_CCLK_VDDC_TABLE,
    PP_OD_EDIT_VDDC_CURVE,
    PP_OD_RESTORE_DEFAULT_TABLE,
    PP_OD_COMMIT_DPM_TABLE,
    PP_OD_EDIT_VDDGFX_OFFSET,
    PP_OD_EDIT_FAN_CURVE,
    PP_OD_EDIT_ACOUSTIC_LIMIT,
    PP_OD_EDIT_ACOUSTIC_TARGET,
    PP_OD_EDIT_FAN_TARGET_TEMPERATURE,
    PP_OD_EDIT_FAN_MINIMUM_PWM,
    PP_OD_EDIT_FAN_ZERO_RPM_ENABLE,
    PP_OD_EDIT_FAN_ZERO_RPM_STOP_TEMP,
}

struct pp_states_info
{
    uint     nums;
    uint[16] states;
}

enum PP_HWMON_TEMP
{
    PP_TEMP_EDGE = 0,
    PP_TEMP_JUNCTION,
    PP_TEMP_MEM,
    PP_TEMP_MAX
}

enum pp_mp1_state
{
    PP_MP1_STATE_NONE,
    PP_MP1_STATE_SHUTDOWN,
    PP_MP1_STATE_UNLOAD,
    PP_MP1_STATE_RESET,
    PP_MP1_STATE_FLR,
}

enum pp_df_cstate
{
    DF_CSTATE_DISALLOW = 0,
    DF_CSTATE_ALLOW,
}

/**
 * DOC: amdgpu_pp_power
 *
 * APU power is managed to system-level requirements through the PPT
 * (package power tracking) feature. PPT is intended to limit power to the
 * requirements of the power source and could be dynamically updated to
 * maximize APU performance within the system power budget.
 *
 * Two types of power measurement can be requested, where supported, with
 * :c:type:`enum pp_power_type <pp_power_type>`.
 */

/**
 * enum pp_power_limit_level - Used to query the power limits
 *
 * @PP_PWR_LIMIT_MIN: Minimum Power Limit
 * @PP_PWR_LIMIT_CURRENT: Current Power Limit
 * @PP_PWR_LIMIT_DEFAULT: Default Power Limit
 * @PP_PWR_LIMIT_MAX: Maximum Power Limit
 */
enum pp_power_limit_level
{
    PP_PWR_LIMIT_MIN = -1,
    PP_PWR_LIMIT_CURRENT,
    PP_PWR_LIMIT_DEFAULT,
    PP_PWR_LIMIT_MAX,
}

/**
 * enum pp_power_type - Used to specify the type of the requested power
 *
 * @PP_PWR_TYPE_SUSTAINED: manages the configurable, thermally significant
 * moving average of APU power (default ~5000 ms).
 * @PP_PWR_TYPE_FAST: manages the ~10 ms moving average of APU power,
 * where supported.
 */
enum pp_power_type
{
    PP_PWR_TYPE_SUSTAINED,
    PP_PWR_TYPE_FAST,
}

enum pp_xgmi_plpd_mode
{
    XGMI_PLPD_NONE = -1,
    XGMI_PLPD_DISALLOW,
    XGMI_PLPD_DEFAULT,
    XGMI_PLPD_OPTIMIZED,
    XGMI_PLPD_COUNT,
}

enum pp_pm_policy
{
    PP_PM_POLICY_NONE = -1,
    PP_PM_POLICY_SOC_PSTATE = 0,
    PP_PM_POLICY_XGMI_PLPD,
    PP_PM_POLICY_NUM,
}

enum pp_policy_soc_pstate
{
    SOC_PSTATE_DEFAULT = 0,
    SOC_PSTATE_0,
    SOC_PSTATE_1,
    SOC_PSTATE_2,
    SOC_PSTAT_COUNT,
}

enum PP_POLICY_MAX_LEVELS = 5;

enum PP_GROUP_MASK        = 0xF0000000;
enum PP_GROUP_SHIFT       = 28;

enum PP_BLOCK_MASK        = 0x0FFFFF00;
enum PP_BLOCK_SHIFT       = 8;

enum PP_BLOCK_GFX_CG         = 0x01;
enum PP_BLOCK_GFX_MG         = 0x02;
enum PP_BLOCK_GFX_3D         = 0x04;
enum PP_BLOCK_GFX_RLC        = 0x08;
enum PP_BLOCK_GFX_CP         = 0x10;
enum PP_BLOCK_SYS_BIF        = 0x01;
enum PP_BLOCK_SYS_MC         = 0x02;
enum PP_BLOCK_SYS_ROM        = 0x04;
enum PP_BLOCK_SYS_DRM        = 0x08;
enum PP_BLOCK_SYS_HDP        = 0x10;
enum PP_BLOCK_SYS_SDMA       = 0x20;

enum PP_STATE_MASK           = 0x0000000F;
enum PP_STATE_SHIFT          = 0;
enum PP_STATE_SUPPORT_MASK   = 0x000000F0;
enum PP_STATE_SUPPORT_SHIFT  = 0;

enum PP_STATE_CG             = 0x01;
enum PP_STATE_LS             = 0x02;
enum PP_STATE_DS             = 0x04;
enum PP_STATE_SD             = 0x08;
enum PP_STATE_SUPPORT_CG     = 0x10;
enum PP_STATE_SUPPORT_LS     = 0x20;
enum PP_STATE_SUPPORT_DS     = 0x40;
enum PP_STATE_SUPPORT_SD     = 0x80;

/*
enum PP_CG_MSG_ID(group, block, support, state) = \;
        ((group) << PP_GROUP_SHIFT | (block) << PP_BLOCK_SHIFT | \
        (support) << PP_STATE_SUPPORT_SHIFT | (state) << PP_STATE_SHIFT)
        */

enum XGMI_MODE_PSTATE_D3 = 0;
enum XGMI_MODE_PSTATE_D0 = 1;

enum NUM_HBM_INSTANCES = 4;
enum NUM_XGMI_LINKS = 8;
enum MAX_GFX_CLKS = 8;
enum MAX_CLKS = 4;
enum NUM_VCN = 4;
enum NUM_JPEG_ENG = 32;
enum NUM_JPEG_ENG_V1 = 40;
enum MAX_XCC = 8;
enum NUM_XCP = 8;

struct metrics_table_header
{
    align(1):
    ushort structure_size;
    ubyte format_revision;
    ubyte content_revision;
}

/*
 * gpu_metrics_v1_0 is not recommended as it's not naturally aligned.
 * Use gpu_metrics_v1_1 or later instead.
 */
struct gpu_metrics_v1_0
{
    align(1):
    metrics_table_header common_header;

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Temperature */
    ushort temperature_edge;
    ushort temperature_hotspot;
    ushort temperature_mem;
    ushort temperature_vrgfx;
    ushort temperature_vrsoc;
    ushort temperature_vrmem;

    /* Utilization */
    ushort average_gfx_activity;
    ushort average_umc_activity; // memory controller
    ushort average_mm_activity; // UVD or VCN

    /* Power/Energy */
    ushort average_socket_power;
    uint energy_accumulator;

    /* Average clocks */
    ushort average_gfxclk_frequency;
    ushort average_socclk_frequency;
    ushort average_uclk_frequency;
    ushort average_vclk0_frequency;
    ushort average_dclk0_frequency;
    ushort average_vclk1_frequency;
    ushort average_dclk1_frequency;

    /* Current clocks */
    ushort current_gfxclk;
    ushort current_socclk;
    ushort current_uclk;
    ushort current_vclk0;
    ushort current_dclk0;
    ushort current_vclk1;
    ushort current_dclk1;

    /* Throttle status */
    uint throttle_status;

    /* Fans */
    ushort current_fan_speed;

    /* Link width/speed */
    ubyte pcie_link_width;
    ubyte pcie_link_speed; // in 0.1 GT/s
}

struct gpu_metrics_v1_1
{
    align(1):
    metrics_table_header common_header;

    /* Temperature */
    ushort temperature_edge;
    ushort temperature_hotspot;
    ushort temperature_mem;
    ushort temperature_vrgfx;
    ushort temperature_vrsoc;
    ushort temperature_vrmem;

    /* Utilization */
    ushort average_gfx_activity;
    ushort average_umc_activity; // memory controller
    ushort average_mm_activity; // UVD or VCN

    /* Power/Energy */
    ushort average_socket_power;
    ulong energy_accumulator;

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Average clocks */
    ushort average_gfxclk_frequency;
    ushort average_socclk_frequency;
    ushort average_uclk_frequency;
    ushort average_vclk0_frequency;
    ushort average_dclk0_frequency;
    ushort average_vclk1_frequency;
    ushort average_dclk1_frequency;

    /* Current clocks */
    ushort current_gfxclk;
    ushort current_socclk;
    ushort current_uclk;
    ushort current_vclk0;
    ushort current_dclk0;
    ushort current_vclk1;
    ushort current_dclk1;

    /* Throttle status */
    uint throttle_status;

    /* Fans */
    ushort current_fan_speed;

    /* Link width/speed */
    ushort pcie_link_width;
    ushort pcie_link_speed; // in 0.1 GT/s

    ushort padding;

    uint gfx_activity_acc;
    uint mem_activity_acc;

    ushort[NUM_HBM_INSTANCES] temperature_hbm;
}

struct gpu_metrics_v1_2
{
    align(1):
    metrics_table_header common_header;

    /* Temperature */
    ushort temperature_edge;
    ushort temperature_hotspot;
    ushort temperature_mem;
    ushort temperature_vrgfx;
    ushort temperature_vrsoc;
    ushort temperature_vrmem;

    /* Utilization */
    ushort average_gfx_activity;
    ushort average_umc_activity; // memory controller
    ushort average_mm_activity; // UVD or VCN

    /* Power/Energy */
    ushort average_socket_power;
    ulong energy_accumulator;

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Average clocks */
    ushort average_gfxclk_frequency;
    ushort average_socclk_frequency;
    ushort average_uclk_frequency;
    ushort average_vclk0_frequency;
    ushort average_dclk0_frequency;
    ushort average_vclk1_frequency;
    ushort average_dclk1_frequency;

    /* Current clocks */
    ushort current_gfxclk;
    ushort current_socclk;
    ushort current_uclk;
    ushort current_vclk0;
    ushort current_dclk0;
    ushort current_vclk1;
    ushort current_dclk1;

    /* Throttle status (ASIC dependent) */
    uint throttle_status;

    /* Fans */
    ushort current_fan_speed;

    /* Link width/speed */
    ushort pcie_link_width;
    ushort pcie_link_speed; // in 0.1 GT/s

    ushort padding;

    uint gfx_activity_acc;
    uint mem_activity_acc;

    ushort[NUM_HBM_INSTANCES] temperature_hbm;

    /* PMFW attached timestamp (10ns resolution) */
    ulong firmware_timestamp;
}

struct gpu_metrics_v1_3
{
    align(1):
    metrics_table_header common_header;

    /* Temperature */
    ushort temperature_edge;
    ushort temperature_hotspot;
    ushort temperature_mem;
    ushort temperature_vrgfx;
    ushort temperature_vrsoc;
    ushort temperature_vrmem;

    /* Utilization */
    ushort average_gfx_activity;
    ushort average_umc_activity; // memory controller
    ushort average_mm_activity; // UVD or VCN

    /* Power/Energy */
    ushort average_socket_power;
    ulong energy_accumulator;

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Average clocks */
    ushort average_gfxclk_frequency;
    ushort average_socclk_frequency;
    ushort average_uclk_frequency;
    ushort average_vclk0_frequency;
    ushort average_dclk0_frequency;
    ushort average_vclk1_frequency;
    ushort average_dclk1_frequency;

    /* Current clocks */
    ushort current_gfxclk;
    ushort current_socclk;
    ushort current_uclk;
    ushort current_vclk0;
    ushort current_dclk0;
    ushort current_vclk1;
    ushort current_dclk1;

    /* Throttle status */
    uint throttle_status;

    /* Fans */
    ushort current_fan_speed;

    /* Link width/speed */
    ushort pcie_link_width;
    ushort pcie_link_speed; // in 0.1 GT/s

    ushort padding;

    uint gfx_activity_acc;
    uint mem_activity_acc;

    ushort[NUM_HBM_INSTANCES] temperature_hbm;

    /* PMFW attached timestamp (10ns resolution) */
    ulong firmware_timestamp;

    /* Voltage (mV) */
    ushort voltage_soc;
    ushort voltage_gfx;
    ushort voltage_mem;

    ushort padding1;

    /* Throttle status (ASIC independent) */
    ulong indep_throttle_status;
}

struct gpu_metrics_v1_4
{
    align(1):
    metrics_table_header common_header;

    /* Temperature (Celsius) */
    ushort temperature_hotspot;
    ushort temperature_mem;
    ushort temperature_vrsoc;

    /* Power (Watts) */
    ushort curr_socket_power;

    /* Utilization (%) */
    ushort average_gfx_activity;
    ushort average_umc_activity; // memory controller
    ushort[NUM_VCN] vcn_activity;

    /* Energy (15.259uJ (2^-16) units) */
    ulong energy_accumulator;

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Throttle status */
    uint throttle_status;

    /* Clock Lock Status. Each bit corresponds to clock instance */
    uint gfxclk_lock_status;

    /* Link width (number of lanes) and speed (in 0.1 GT/s) */
    ushort pcie_link_width;
    ushort pcie_link_speed;

    /* XGMI bus width and bitrate (in Gbps) */
    ushort xgmi_link_width;
    ushort xgmi_link_speed;

    /* Utilization Accumulated (%) */
    uint gfx_activity_acc;
    uint mem_activity_acc;

    /*PCIE accumulated bandwidth (GB/sec) */
    ulong pcie_bandwidth_acc;

    /*PCIE instantaneous bandwidth (GB/sec) */
    ulong pcie_bandwidth_inst;

    /* PCIE L0 to recovery state transition accumulated count */
    ulong pcie_l0_to_recov_count_acc;

    /* PCIE replay accumulated count */
    ulong pcie_replay_count_acc;

    /* PCIE replay rollover accumulated count */
    ulong pcie_replay_rover_count_acc;

    /* XGMI accumulated data transfer size(KiloBytes) */
    ulong[NUM_XGMI_LINKS] xgmi_read_data_acc;
    ulong[NUM_XGMI_LINKS] xgmi_write_data_acc;

    /* PMFW attached timestamp (10ns resolution) */
    ulong firmware_timestamp;

    /* Current clocks (Mhz) */
    ushort[MAX_GFX_CLKS] current_gfxclk;
    ushort[MAX_CLKS] current_socclk;
    ushort[MAX_CLKS] current_vclk0;
    ushort[MAX_CLKS] current_dclk0;
    ushort current_uclk;

    ushort padding;
}

struct gpu_metrics_v1_5
{
    align(1):
    metrics_table_header common_header;

    /* Temperature (Celsius) */
    ushort temperature_hotspot;
    ushort temperature_mem;
    ushort temperature_vrsoc;

    /* Power (Watts) */
    ushort curr_socket_power;

    /* Utilization (%) */
    ushort average_gfx_activity;
    ushort average_umc_activity; // memory controller
    ushort[NUM_VCN] vcn_activity;
    ushort[NUM_JPEG_ENG] jpeg_activity;

    /* Energy (15.259uJ (2^-16) units) */
    ulong energy_accumulator;

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Throttle status */
    uint throttle_status;

    /* Clock Lock Status. Each bit corresponds to clock instance */
    uint gfxclk_lock_status;

    /* Link width (number of lanes) and speed (in 0.1 GT/s) */
    ushort pcie_link_width;
    ushort pcie_link_speed;

    /* XGMI bus width and bitrate (in Gbps) */
    ushort xgmi_link_width;
    ushort xgmi_link_speed;

    /* Utilization Accumulated (%) */
    uint gfx_activity_acc;
    uint mem_activity_acc;

    /*PCIE accumulated bandwidth (GB/sec) */
    ulong pcie_bandwidth_acc;

    /*PCIE instantaneous bandwidth (GB/sec) */
    ulong pcie_bandwidth_inst;

    /* PCIE L0 to recovery state transition accumulated count */
    ulong pcie_l0_to_recov_count_acc;

    /* PCIE replay accumulated count */
    ulong pcie_replay_count_acc;

    /* PCIE replay rollover accumulated count */
    ulong pcie_replay_rover_count_acc;

    /* PCIE NAK sent  accumulated count */
    uint pcie_nak_sent_count_acc;

    /* PCIE NAK received accumulated count */
    uint pcie_nak_rcvd_count_acc;

    /* XGMI accumulated data transfer size(KiloBytes) */
    ulong[NUM_XGMI_LINKS] xgmi_read_data_acc;
    ulong[NUM_XGMI_LINKS] xgmi_write_data_acc;

    /* PMFW attached timestamp (10ns resolution) */
    ulong firmware_timestamp;

    /* Current clocks (Mhz) */
    ushort[MAX_GFX_CLKS] current_gfxclk;
    ushort[MAX_CLKS] current_socclk;
    ushort[MAX_CLKS] current_vclk0;
    ushort[MAX_CLKS] current_dclk0;
    ushort current_uclk;

    ushort padding;
}

struct gpu_metrics_v1_6
{
    align(1):
    metrics_table_header common_header;

    /* Temperature (Celsius) */
    ushort temperature_hotspot;
    ushort temperature_mem;
    ushort temperature_vrsoc;

    /* Power (Watts) */
    ushort curr_socket_power;

    /* Utilization (%) */
    ushort average_gfx_activity;
    ushort average_umc_activity; // memory controller

    /* Energy (15.259uJ (2^-16) units) */
    ulong energy_accumulator;

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Accumulation cycle counter */
    uint accumulation_counter;

    /* Accumulated throttler residencies */
    uint prochot_residency_acc;
    uint ppt_residency_acc;
    uint socket_thm_residency_acc;
    uint vr_thm_residency_acc;
    uint hbm_thm_residency_acc;

    /* Clock Lock Status. Each bit corresponds to clock instance */
    uint gfxclk_lock_status;

    /* Link width (number of lanes) and speed (in 0.1 GT/s) */
    ushort pcie_link_width;
    ushort pcie_link_speed;

    /* XGMI bus width and bitrate (in Gbps) */
    ushort xgmi_link_width;
    ushort xgmi_link_speed;

    /* Utilization Accumulated (%) */
    uint gfx_activity_acc;
    uint mem_activity_acc;

    /*PCIE accumulated bandwidth (GB/sec) */
    ulong pcie_bandwidth_acc;

    /*PCIE instantaneous bandwidth (GB/sec) */
    ulong pcie_bandwidth_inst;

    /* PCIE L0 to recovery state transition accumulated count */
    ulong pcie_l0_to_recov_count_acc;

    /* PCIE replay accumulated count */
    ulong pcie_replay_count_acc;

    /* PCIE replay rollover accumulated count */
    ulong pcie_replay_rover_count_acc;

    /* PCIE NAK sent  accumulated count */
    uint pcie_nak_sent_count_acc;

    /* PCIE NAK received accumulated count */
    uint pcie_nak_rcvd_count_acc;

    /* XGMI accumulated data transfer size(KiloBytes) */
    ulong[NUM_XGMI_LINKS] xgmi_read_data_acc;
    ulong[NUM_XGMI_LINKS] xgmi_write_data_acc;

    /* PMFW attached timestamp (10ns resolution) */
    ulong firmware_timestamp;

    /* Current clocks (Mhz) */
    ushort[MAX_GFX_CLKS] current_gfxclk;
    ushort[MAX_CLKS] current_socclk;
    ushort[MAX_CLKS] current_vclk0;
    ushort[MAX_CLKS] current_dclk0;
    ushort current_uclk;

    /* Number of current partition */
    ushort num_partition;

    /* XCP metrics stats */
    amdgpu_xcp_metrics[NUM_XCP] xcp_stats;

    /* PCIE other end recovery counter */
    uint pcie_lc_perf_other_end_recovery;
}

struct gpu_metrics_v1_7
{
    align(1):
    metrics_table_header common_header;

    /* Temperature (Celsius) */
    ushort temperature_hotspot;
    ushort temperature_mem;
    ushort temperature_vrsoc;

    /* Power (Watts) */
    ushort curr_socket_power;

    /* Utilization (%) */
    ushort average_gfx_activity;
    ushort average_umc_activity; // memory controller

    /* VRAM max bandwidthi (in GB/sec) at max memory clock */
    ulong mem_max_bandwidth;

    /* Energy (15.259uJ (2^-16) units) */
    ulong energy_accumulator;

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Accumulation cycle counter */
    uint accumulation_counter;

    /* Accumulated throttler residencies */
    uint prochot_residency_acc;
    uint ppt_residency_acc;
    uint socket_thm_residency_acc;
    uint vr_thm_residency_acc;
    uint hbm_thm_residency_acc;

    /* Clock Lock Status. Each bit corresponds to clock instance */
    uint gfxclk_lock_status;

    /* Link width (number of lanes) and speed (in 0.1 GT/s) */
    ushort pcie_link_width;
    ushort pcie_link_speed;

    /* XGMI bus width and bitrate (in Gbps) */
    ushort xgmi_link_width;
    ushort xgmi_link_speed;

    /* Utilization Accumulated (%) */
    uint gfx_activity_acc;
    uint mem_activity_acc;

    /*PCIE accumulated bandwidth (GB/sec) */
    ulong pcie_bandwidth_acc;

    /*PCIE instantaneous bandwidth (GB/sec) */
    ulong pcie_bandwidth_inst;

    /* PCIE L0 to recovery state transition accumulated count */
    ulong pcie_l0_to_recov_count_acc;

    /* PCIE replay accumulated count */
    ulong pcie_replay_count_acc;

    /* PCIE replay rollover accumulated count */
    ulong pcie_replay_rover_count_acc;

    /* PCIE NAK sent  accumulated count */
    uint pcie_nak_sent_count_acc;

    /* PCIE NAK received accumulated count */
    uint pcie_nak_rcvd_count_acc;

    /* XGMI accumulated data transfer size(KiloBytes) */
    ulong[NUM_XGMI_LINKS] xgmi_read_data_acc;
    ulong[NUM_XGMI_LINKS] xgmi_write_data_acc;

    /* XGMI link status(active/inactive) */
    ushort[NUM_XGMI_LINKS] xgmi_link_status;

    ushort padding;

    /* PMFW attached timestamp (10ns resolution) */
    ulong firmware_timestamp;

    /* Current clocks (Mhz) */
    ushort[MAX_GFX_CLKS] current_gfxclk;
    ushort[MAX_CLKS] current_socclk;
    ushort[MAX_CLKS] current_vclk0;
    ushort[MAX_CLKS] current_dclk0;
    ushort current_uclk;

    /* Number of current partition */
    ushort num_partition;

    /* XCP metrics stats */
    amdgpu_xcp_metrics_v1_1[NUM_XCP] xcp_stats;

    /* PCIE other end recovery counter */
    uint pcie_lc_perf_other_end_recovery;
}

struct gpu_metrics_v1_8
{
    align(1):
    metrics_table_header common_header;

    /* Temperature (Celsius) */
    ushort temperature_hotspot;
    ushort temperature_mem;
    ushort temperature_vrsoc;

    /* Power (Watts) */
    ushort curr_socket_power;

    /* Utilization (%) */
    ushort average_gfx_activity;
    ushort average_umc_activity; // memory controller

    /* VRAM max bandwidthi (in GB/sec) at max memory clock */
    ulong mem_max_bandwidth;

    /* Energy (15.259uJ (2^-16) units) */
    ulong energy_accumulator;

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Accumulation cycle counter */
    uint accumulation_counter;

    /* Accumulated throttler residencies */
    uint prochot_residency_acc;
    uint ppt_residency_acc;
    uint socket_thm_residency_acc;
    uint vr_thm_residency_acc;
    uint hbm_thm_residency_acc;

    /* Clock Lock Status. Each bit corresponds to clock instance */
    uint gfxclk_lock_status;

    /* Link width (number of lanes) and speed (in 0.1 GT/s) */
    ushort pcie_link_width;
    ushort pcie_link_speed;

    /* XGMI bus width and bitrate (in Gbps) */
    ushort xgmi_link_width;
    ushort xgmi_link_speed;

    /* Utilization Accumulated (%) */
    uint gfx_activity_acc;
    uint mem_activity_acc;

    /*PCIE accumulated bandwidth (GB/sec) */
    ulong pcie_bandwidth_acc;

    /*PCIE instantaneous bandwidth (GB/sec) */
    ulong pcie_bandwidth_inst;

    /* PCIE L0 to recovery state transition accumulated count */
    ulong pcie_l0_to_recov_count_acc;

    /* PCIE replay accumulated count */
    ulong pcie_replay_count_acc;

    /* PCIE replay rollover accumulated count */
    ulong pcie_replay_rover_count_acc;

    /* PCIE NAK sent  accumulated count */
    uint pcie_nak_sent_count_acc;

    /* PCIE NAK received accumulated count */
    uint pcie_nak_rcvd_count_acc;

    /* XGMI accumulated data transfer size(KiloBytes) */
    ulong[NUM_XGMI_LINKS] xgmi_read_data_acc;
    ulong[NUM_XGMI_LINKS] xgmi_write_data_acc;

    /* XGMI link status(active/inactive) */
    ushort[NUM_XGMI_LINKS] xgmi_link_status;

    ushort padding;

    /* PMFW attached timestamp (10ns resolution) */
    ulong firmware_timestamp;

    /* Current clocks (Mhz) */
    ushort[MAX_GFX_CLKS] current_gfxclk;
    ushort[MAX_CLKS] current_socclk;
    ushort[MAX_CLKS] current_vclk0;
    ushort[MAX_CLKS] current_dclk0;
    ushort current_uclk;

    /* Number of current partition */
    ushort num_partition;

    /* XCP metrics stats */
    amdgpu_xcp_metrics_v1_2[NUM_XCP] xcp_stats;

    /* PCIE other end recovery counter */
    uint pcie_lc_perf_other_end_recovery;
}

/*
 * gpu_metrics_v2_0 is not recommended as it's not naturally aligned.
 * Use gpu_metrics_v2_1 or later instead.
 */
struct gpu_metrics_v2_0
{
    align(1):
    metrics_table_header common_header;

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Temperature */
    ushort temperature_gfx; // gfx temperature on APUs
    ushort temperature_soc; // soc temperature on APUs
    ushort[8] temperature_core; // CPU core on APU temperatures
    ushort[2] temperature_l3;

    /* Utilization */
    ushort average_gfx_activity;
    ushort average_mm_activity; // UVD or VCN

    /* Power/Energy */
    ushort average_socket_power; // dGPU + APU power on A + A platform
    ushort average_cpu_power;
    ushort average_soc_power;
    ushort average_gfx_power;
    ushort[8] average_core_power; // CPU core on APU powers

    /* Average clocks */
    ushort average_gfxclk_frequency;
    ushort average_socclk_frequency;
    ushort average_uclk_frequency;
    ushort average_fclk_frequency;
    ushort average_vclk_frequency;
    ushort average_dclk_frequency;

    /* Current clocks */
    ushort current_gfxclk;
    ushort current_socclk;
    ushort current_uclk;
    ushort current_fclk;
    ushort current_vclk;
    ushort current_dclk;
    ushort[8] current_coreclk; // core clock CPUs
    ushort[2] current_l3clk;

    /* Throttle status */
    uint throttle_status;

    /* Fans */
    ushort fan_pwm;

    ushort padding;
}

struct gpu_metrics_v2_1
{
    align(1):
    metrics_table_header common_header;

    /* Temperature */
    ushort temperature_gfx; // gfx temperature on APUs
    ushort temperature_soc; // soc temperature on APUs
    ushort[8] temperature_core; // CPU core on APU temperatures
    ushort[2] temperature_l3;

    /* Utilization */
    ushort average_gfx_activity;
    ushort average_mm_activity; // UVD or VCN

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Power/Energy */
    ushort average_socket_power; // dGPU + APU power on A + A platform
    ushort average_cpu_power;
    ushort average_soc_power;
    ushort average_gfx_power;
    ushort[8] average_core_power; // CPU core on APU powers

    /* Average clocks */
    ushort average_gfxclk_frequency;
    ushort average_socclk_frequency;
    ushort average_uclk_frequency;
    ushort average_fclk_frequency;
    ushort average_vclk_frequency;
    ushort average_dclk_frequency;

    /* Current clocks */
    ushort current_gfxclk;
    ushort current_socclk;
    ushort current_uclk;
    ushort current_fclk;
    ushort current_vclk;
    ushort current_dclk;
    ushort[8] current_coreclk; // core clock CPUs
    ushort[2] current_l3clk;

    /* Throttle status */
    uint throttle_status;

    /* Fans */
    ushort fan_pwm;

    ushort[3] padding;
}

struct gpu_metrics_v2_2
{
    align(1):
    metrics_table_header common_header;

    /* Temperature */
    ushort temperature_gfx; // gfx temperature on APUs
    ushort temperature_soc; // soc temperature on APUs
    ushort[8] temperature_core; // CPU core on APU temperatures
    ushort[2] temperature_l3;

    /* Utilization */
    ushort average_gfx_activity;
    ushort average_mm_activity; // UVD or VCN

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Power/Energy */
    ushort average_socket_power; // dGPU + APU power on A + A platform
    ushort average_cpu_power;
    ushort average_soc_power;
    ushort average_gfx_power;
    ushort[8] average_core_power; // CPU core on APU powers

    /* Average clocks */
    ushort average_gfxclk_frequency;
    ushort average_socclk_frequency;
    ushort average_uclk_frequency;
    ushort average_fclk_frequency;
    ushort average_vclk_frequency;
    ushort average_dclk_frequency;

    /* Current clocks */
    ushort current_gfxclk;
    ushort current_socclk;
    ushort current_uclk;
    ushort current_fclk;
    ushort current_vclk;
    ushort current_dclk;
    ushort[8] current_coreclk; // core clock CPUs
    ushort[2] current_l3clk;

    /* Throttle status (ASIC dependent) */
    uint throttle_status;

    /* Fans */
    ushort fan_pwm;

    ushort[3] padding;

    /* Throttle status (ASIC independent) */
    ulong indep_throttle_status;
}

struct gpu_metrics_v2_3
{
    align(1):
    metrics_table_header common_header;

    /* Temperature */
    ushort temperature_gfx; // gfx temperature on APUs
    ushort temperature_soc; // soc temperature on APUs
    ushort[8] temperature_core; // CPU core on APU temperatures
    ushort[2] temperature_l3;

    /* Utilization */
    ushort average_gfx_activity;
    ushort average_mm_activity; // UVD or VCN

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Power/Energy */
    ushort average_socket_power; // dGPU + APU power on A + A platform
    ushort average_cpu_power;
    ushort average_soc_power;
    ushort average_gfx_power;
    ushort[8] average_core_power; // CPU core on APU powers

    /* Average clocks */
    ushort average_gfxclk_frequency;
    ushort average_socclk_frequency;
    ushort average_uclk_frequency;
    ushort average_fclk_frequency;
    ushort average_vclk_frequency;
    ushort average_dclk_frequency;

    /* Current clocks */
    ushort current_gfxclk;
    ushort current_socclk;
    ushort current_uclk;
    ushort current_fclk;
    ushort current_vclk;
    ushort current_dclk;
    ushort[8] current_coreclk; // core clock CPUs
    ushort[2] current_l3clk;

    /* Throttle status (ASIC dependent) */
    uint throttle_status;

    /* Fans */
    ushort fan_pwm;

    ushort[3] padding;

    /* Throttle status (ASIC independent) */
    ulong indep_throttle_status;

    /* Average Temperature */
    ushort average_temperature_gfx; // average gfx temperature on APUs
    ushort average_temperature_soc; // average soc temperature on APUs
    ushort[8] average_temperature_core; // average CPU core on APU temperatures
    ushort[2] average_temperature_l3;
};

struct gpu_metrics_v2_4
{
    align(1):
    metrics_table_header common_header;

    /* Temperature (unit: centi-Celsius) */
    ushort temperature_gfx;
    ushort temperature_soc;
    ushort[8] temperature_core;
    ushort[2] temperature_l3;

    /* Utilization (unit: centi) */
    ushort average_gfx_activity;
    ushort average_mm_activity;

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Power/Energy (unit: mW) */
    ushort average_socket_power;
    ushort average_cpu_power;
    ushort average_soc_power;
    ushort average_gfx_power;
    ushort[8] average_core_power;

    /* Average clocks (unit: MHz) */
    ushort average_gfxclk_frequency;
    ushort average_socclk_frequency;
    ushort average_uclk_frequency;
    ushort average_fclk_frequency;
    ushort average_vclk_frequency;
    ushort average_dclk_frequency;

    /* Current clocks (unit: MHz) */
    ushort current_gfxclk;
    ushort current_socclk;
    ushort current_uclk;
    ushort current_fclk;
    ushort current_vclk;
    ushort current_dclk;
    ushort[8] current_coreclk;
    ushort[2] current_l3clk;

    /* Throttle status (ASIC dependent) */
    uint throttle_status;

    /* Fans */
    ushort fan_pwm;

    ushort[3] padding;

    /* Throttle status (ASIC independent) */
    ulong indep_throttle_status;

    /* Average Temperature (unit: centi-Celsius) */
    ushort average_temperature_gfx;
    ushort average_temperature_soc;
    ushort[8] average_temperature_core;
    ushort[2] average_temperature_l3;

    /* Power/Voltage (unit: mV) */
    ushort average_cpu_voltage;
    ushort average_soc_voltage;
    ushort average_gfx_voltage;

    /* Power/Current (unit: mA) */
    ushort average_cpu_current;
    ushort average_soc_current;
    ushort average_gfx_current;
}

struct gpu_metrics_v3_0
{
    align(1):
    metrics_table_header common_header;

    /* Temperature */
    /* gfx temperature on APUs */
    ushort temperature_gfx;
    /* soc temperature on APUs */
    ushort temperature_soc;
    /* CPU core temperature on APUs */
    ushort[16] temperature_core;
    /* skin temperature on APUs */
    ushort temperature_skin;

    /* Utilization */
    /* time filtered GFX busy % [0-100] */
    ushort average_gfx_activity;
    /* time filtered VCN busy % [0-100] */
    ushort average_vcn_activity;
    /* time filtered IPU per-column busy % [0-100] */
    ushort[8] average_ipu_activity;
    /* time filtered per-core C0 residency % [0-100]*/
    ushort[16] average_core_c0_activity;
    /* time filtered DRAM read bandwidth [MB/sec] */
    ushort average_dram_reads;
    /* time filtered DRAM write bandwidth [MB/sec] */
    ushort average_dram_writes;
    /* time filtered IPU read bandwidth [MB/sec] */
    ushort average_ipu_reads;
    /* time filtered IPU write bandwidth [MB/sec] */
    ushort average_ipu_writes;

    /* Driver attached timestamp (in ns) */
    ulong system_clock_counter;

    /* Power/Energy */
    /* time filtered power used for PPT/STAPM [APU+dGPU] [mW] */
    uint average_socket_power;
    /* time filtered IPU power [mW] */
    ushort average_ipu_power;
    /* time filtered APU power [mW] */
    uint average_apu_power;
    /* time filtered GFX power [mW] */
    uint average_gfx_power;
    /* time filtered dGPU power [mW] */
    uint average_dgpu_power;
    /* time filtered sum of core power across all cores in the socket [mW] */
    uint average_all_core_power;
    /* calculated core power [mW] */
    ushort[16] average_core_power;
    /* time filtered total system power [mW] */
    ushort average_sys_power;
    /* maximum IRM defined STAPM power limit [mW] */
    ushort stapm_power_limit;
    /* time filtered STAPM power limit [mW] */
    ushort current_stapm_power_limit;

    /* time filtered clocks [MHz] */
    ushort average_gfxclk_frequency;
    ushort average_socclk_frequency;
    ushort average_vpeclk_frequency;
    ushort average_ipuclk_frequency;
    ushort average_fclk_frequency;
    ushort average_vclk_frequency;
    ushort average_uclk_frequency;
    ushort average_mpipu_frequency;

    /* Current clocks */
    /* target core frequency [MHz] */
    ushort[16] current_coreclk;
    /* CCLK frequency limit enforced on classic cores [MHz] */
    ushort current_core_maxfreq;
    /* GFXCLK frequency limit enforced on GFX [MHz] */
    ushort current_gfx_maxfreq;

    /* Throttle Residency (ASIC dependent) */
    uint throttle_residency_prochot;
    uint throttle_residency_spl;
    uint throttle_residency_fppt;
    uint throttle_residency_sppt;
    uint throttle_residency_thm_core;
    uint throttle_residency_thm_gfx;
    uint throttle_residency_thm_soc;

    /* Metrics table alpha filter time constant [us] */
    uint time_filter_alphavalue;
}

/*
struct amdgpu_pmmetrics_header
{
    ushort structure_size;
    ushort pad;
    uint mp1_ip_discovery_version;
    uint pmfw_version;
    uint pmmetrics_version;
};

struct amdgpu_pm_metrics
{
    struct amdgpu_pmmetrics_header common_header;

    uint8_t data[];
};
*/