#ifndef LCD_HDC_MODELS_H
#define LCD_HDC_MODELS_H
#include "hdc_model_store.h"
#define HDC_MODEL_ROWS 6u
static sd_model_entry hdc_models[HDC_MODEL_ROWS];
static uint32_t hdc_model_count,hdc_model_more,hdc_model_after,hdc_model_selected,hdc_model_error,hdc_model_status;
static char hdc_model_current[13];
static u32 hdc_model_idle(void)
{
    return lcd_hdc_view && hdc_model_view && !ui_menu_open && g_mode==MODE_MONITOR &&
        !sd_record_active() && !hdc.armed && hdc.stage!=HDC_BUILD &&
        (!rehab_running(&rehab) || rehab.state==RH_PAUSED);
}
static void hdc_model_calibration(uint32_t signature[13])
{
    u32 i;signature[0]=hand_profile.cal_mask;
    for(i=0;i<6u;i++){signature[i+1u]=hand_profile.low[i];signature[i+7u]=hand_profile.high[i];}
}
static void hdc_model_refresh(void)
{
    hdc_model_selected=UINT32_MAX;
    hdc_model_error=sd_model_list(hdc_model_after,hdc_models,HDC_MODEL_ROWS,&hdc_model_count,&hdc_model_more);
    if(hdc_model_error)hdc_model_count=hdc_model_more=0u;
}
static void hdc_model_apply(u32 action)
{
    hdc_model_io io={0};u32 i,j,mapping_reset=0u;uint32_t signature[13];
    if(!hdc_model_idle())return;
    hdc_model_error=0u;hdc_model_status=0u;
    if(action==1u){hdc_model_after=0u;hdc_model_refresh();}
    else if(action==4u){
        if(hdc_model_more && hdc_model_count){hdc_model_after=hdc_models[hdc_model_count-1u].id+1u;hdc_model_refresh();}
    } else if(action==5u){
        /* Find previous page by rescanning bounded pages, no model-count cap. */
        u32 target=hdc_model_after,previous=0u,next=0u;
        hdc_model_after=0u;hdc_model_refresh();
        while(!hdc_model_error && hdc_model_more && hdc_model_count){
            next=hdc_models[hdc_model_count-1u].id+1u;if(next>=target)break;
            previous=next;hdc_model_after=next;hdc_model_refresh();
        }
        hdc_model_after=previous;hdc_model_refresh();
    } else if(action==2u){
        if(hdc.stage!=HDC_DONE){hdc_model_status=4u;goto changed;}
        hand_stop();hand_hdc_reset();hdc_interrupt(&hdc);virtual_hdc_margin=0u;
        io.model=&hdc;io.shift=0u;hdc_model_calibration(io.calibration);
        {char name[13];hdc_model_error=sd_model_save(hdc_model_stream,&io,name);
         if(!hdc_model_error){memcpy(hdc_model_current,name,13u);hdc_model_status=1u;hdc_model_after=0u;
             hdc_model_refresh();}}
    } else if(action==3u){
        char name[13];
        if(hdc_model_selected>=hdc_model_count)return;
        memcpy(name,hdc_models[hdc_model_selected].name,13u);
        hand_stop();hand_hdc_reset();hdc_interrupt(&hdc);virtual_hdc_margin=0u;ui_preview_cls=-1;
        hdc_model_error=hdc_model_restore(&hdc,name,&io);
        if(!hdc_model_error){
            hdc_custom=hdc.classes;hdc_page=0u;
            hdc_max_ticks=hdc_build_max_ticks=hdc_saved=hdc_save_error=0u;hdc_report_name[0]=0;
            hdc_model_calibration(signature);
            for(i=0u;i<hdc.classes;i++)if(hdc.hand_mapped[i]){
                u32 valid=signature[0]==4095u && !memcmp(signature,io.calibration,sizeof signature);
                for(j=1u;j<6u;j++)if(hdc.hand_pose[i][j]<hand_profile.low[j] || hdc.hand_pose[i][j]>hand_profile.high[j])valid=0u;
                if(!valid){hdc.hand_mapped[i]=0u;mapping_reset=1u;}
            }
            virtual_row=0u;virtual_load(virtual_row);hand_row=0u;
            memcpy(hdc_model_current,name,13u);hdc_model_status=mapping_reset?3u:2u;
        }
    }
changed:
    ui_generation++;lcd_pending=1u;lcd_input_status_changed();
}
static void lcd_hdc_models_touch(u32 x,u32 y)
{
    u32 i;
    if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(524),LCD_X(170),LCD_Y(54))){
        ui_hdc_model=0u;hdc_model_view=0u;ui_generation++;lcd_input_status_changed();return;
    }
    if(!hdc_model_idle())return;
    if(lcd_wave_hit(x,y,LCD_X(220),LCD_Y(524),LCD_X(240),LCD_Y(54))){ui_hdc_model=2u;return;}
    if(lcd_wave_hit(x,y,LCD_X(482),LCD_Y(524),LCD_X(240),LCD_Y(54))){ui_hdc_model=3u;return;}
    if(lcd_wave_hit(x,y,LCD_X(744),LCD_Y(524),LCD_X(244),LCD_Y(54))){ui_hdc_save=1u;return;}
    if(lcd_wave_hit(x,y,LCD_X(650),LCD_Y(114),LCD_X(160),LCD_Y(40))){ui_hdc_model=5u;return;}
    if(lcd_wave_hit(x,y,LCD_X(830),LCD_Y(114),LCD_X(160),LCD_Y(40))){ui_hdc_model=4u;return;}
    if(lcd_wave_hit(x,y,LCD_X(480),LCD_Y(114),LCD_X(150),LCD_Y(40))){ui_hdc_model=1u;return;}
    for(i=0;i<hdc_model_count;i++)if(lcd_wave_hit(x,y,LCD_X(28),LCD_Y(184+46u*i),LCD_X(960),LCD_Y(40))){
        hdc_model_selected=i;ui_generation++;lcd_input_status_changed();return;
    }
}
static void lcd_hdc_models_render(void)
{
    char text[96];u32 i;
    p_rect(0,LCD_Y(92),LCD_W,LCD_H-LCD_Y(92),248,250,250);
    ui_label(LCD_X(28),LCD_Y(112),LCD_X(430),2,31,49,58,"HDC 模型库");
    ui_button(LCD_X(480),LCD_Y(114),LCD_X(150),LCD_Y(40),"刷新",0u);
    ui_button(LCD_X(650),LCD_Y(114),LCD_X(160),LCD_Y(40),"上一页",0u);
    ui_button(LCD_X(830),LCD_Y(114),LCD_X(160),LCD_Y(40),"下一页",0u);
    if(!hdc_model_count)ui_label(LCD_X(45),LCD_Y(220),LCD_X(900),2,94,112,119,"暂无模型 / 完成学习后另存");
    for(i=0;i<hdc_model_count;i++)ui_button(LCD_X(28),LCD_Y(184+46u*i),LCD_X(960),LCD_Y(40),
        hdc_models[i].name,hdc_model_selected==i);
    if(hdc_model_current[0]){
        memcpy(text,"最近存取 ",sizeof "最近存取 "-1u);memcpy(text+sizeof "最近存取 "-1u,hdc_model_current,13u);
    }else memcpy(text,"本次尚未存取模型",sizeof "本次尚未存取模型");
    ui_label(LCD_X(28),LCD_Y(468),LCD_X(480),1,31,49,58,text);
    lcd_analysis_label(text,sizeof text,"类别 ",hdc.classes,hdc_hand_model_ready()?" / 验证通过":" / 未通过验证");
    ui_label(LCD_X(520),LCD_Y(468),LCD_X(470),1,25,120,111,text);
    if(hdc_model_error)lcd_analysis_label(text,sizeof text,"SD 错误 ",hdc_model_error," / 当前模型保留");
    else if(!hdc_model_idle())memcpy(text,"请停止采样、录制和训练",sizeof "请停止采样、录制和训练");
    else if(hdc_model_status==4u)memcpy(text,"请先完成学习和独立验证",sizeof "请先完成学习和独立验证");
    else if(hdc_model_status==3u)memcpy(text,"模型已加载 / 机械手映射需确认",sizeof "模型已加载 / 机械手映射需确认");
    else if(hdc_model_status==2u)memcpy(text,"模型已加载 / 联动未启用",sizeof "模型已加载 / 联动未启用");
    else if(hdc_model_status==1u)memcpy(text,"模型已另存 / 断电保留",sizeof "模型已另存 / 断电保留");
    else if(hdc_saved)memcpy(text,hdc_report_name,sizeof hdc_report_name);
    else memcpy(text,"选模型后加载 / 另存保留历史版本",sizeof "选模型后加载 / 另存保留历史版本");
    ui_label(LCD_X(28),LCD_Y(495),LCD_X(960),1,162,101,24,text);
    ui_button(LCD_X(28),LCD_Y(524),LCD_X(170),LCD_Y(54),"返回学习",0u);
    ui_button(LCD_X(220),LCD_Y(524),LCD_X(240),LCD_Y(54),"另存当前模型",0u);
    ui_button(LCD_X(482),LCD_Y(524),LCD_X(240),LCD_Y(54),"加载所选模型",0u);
    ui_button(LCD_X(744),LCD_Y(524),LCD_X(244),LCD_Y(54),"导出验证结果",hdc_saved);
}
#endif

