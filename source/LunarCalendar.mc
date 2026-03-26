import Toybox.Lang;

// 农历转换核心类
class LunarCalendar {
    private const START_YEAR = 2026;
    private const END_YEAR = 2035;
    private const TIANGAN = ["甲", "乙", "丙", "丁", "戊", "己", "庚", "辛", "壬", "癸"];
    private const DIZHI = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"];
    private const LUNAR_MONTHS = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "冬月", "腊月"];
    private const LUNAR_DAYS = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十","十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十","廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"];
    private const SOLAR_TERMS = ["小寒", "大寒", "立春", "雨水", "惊蛰", "春分", "清明", "谷雨", "立夏", "小满", "芒种", "夏至", "小暑", "大暑", "立秋", "处暑", "白露", "秋分", "寒露", "霜降", "立冬", "小雪", "大雪", "冬至"];
    private const LUNAR_OFFSET_DAYS = [
        47, 77, 106, 136, 165, 194, 224, 253, 282, 312, 342, 372,
        401, 431, 461, 490, 520, 549, 578, 608, 637, 666, 696, 726,
        755, 785, 815, 845, 874, 904, 933, 962, 992, 1021, 1050, 1080, 1110,
        1139, 1169, 1199, 1228, 1258, 1287, 1317, 1346, 1376, 1405, 1434, 1464,
        1494, 1523, 1553, 1582, 1612, 1642, 1671, 1701, 1730, 1760, 1789, 1819,
        1848, 1877, 1907, 1937, 1966, 1996, 2025, 2055, 2085, 2114, 2144, 2173, 2203,
        2232, 2262, 2291, 2320, 2350, 2379, 2409, 2439, 2468, 2498, 2528, 2557,
        2587, 2616, 2646, 2675, 2704, 2734, 2763, 2793, 2822, 2852, 2882, 2912, 2941,
        2971, 3000, 3030, 3059, 3088, 3118, 3147, 3177, 3206, 3236, 3266, 3295,
        3325, 3355, 3384, 3414, 3443, 3472, 3502, 3531, 3560, 3590, 3620, 3649
    ];
    private const LEAP_MONTH_OFFSETS = [29, 64, 97];
    private const SOLAR_TERMS_OFFSETS = [
        4, 19, 34, 48, 63, 78, 94, 109, 124, 140, 155, 171, 187, 203, 218, 234, 249, 265, 280, 295, 310, 325, 340, 355,
        369, 384, 399, 414, 429, 444, 459, 474, 490, 505, 521, 536, 552, 568, 584, 599, 615, 630, 645, 660, 675, 690, 705, 720,
        735, 749, 764, 779, 794, 809, 824, 839, 855, 870, 886, 902, 917, 933, 949, 964, 980, 995, 1011, 1026, 1041, 1056, 1070, 1085,
        1100, 1115, 1129, 1144, 1159, 1174, 1189, 1205, 1220, 1236, 1251, 1267, 1283, 1298, 1314, 1330, 1345, 1361, 1376, 1391, 1406, 1421, 1436, 1450,
        1465, 1480, 1495, 1509, 1524, 1539, 1555, 1570, 1585, 1601, 1616, 1632, 1648, 1664, 1679, 1695, 1710, 1726, 1741, 1756, 1771, 1786, 1801, 1816,
        1830, 1845, 1860, 1875, 1890, 1905, 1920, 1935, 1951, 1966, 1982, 1997, 2013, 2029, 2045, 2060, 2076, 2091, 2106, 2121, 2136, 2151, 2166, 2181,
        2196, 2210, 2225, 2240, 2255, 2270, 2285, 2300, 2316, 2331, 2347, 2363, 2378, 2394, 2410, 2425, 2441, 2456, 2472, 2487, 2502, 2517, 2531, 2546,
        2561, 2576, 2590, 2605, 2620, 2635, 2650, 2666, 2681, 2697, 2712, 2728, 2744, 2759, 2775, 2791, 2806, 2822, 2837, 2852, 2867, 2882, 2897, 2911,
        2926, 2941, 2956, 2970, 2985, 3000, 3016, 3031, 3046, 3062, 3077, 3093, 3109, 3125, 3140, 3156, 3171, 3187, 3202, 3217, 3232, 3247, 3262, 3277,
        3291, 3306, 3321, 3336, 3351, 3366, 3381, 3396, 3411, 3427, 3443, 3458, 3474, 3490, 3505, 3521, 3537, 3552, 3567, 3582, 3597, 3612, 3627, 3642
    ];

    // 获取农历日期字符串
    function getLunarDateString(year as Number, month as Number, day as Number) as String {
        // 检查年份是否在支持范围内
        if (year < START_YEAR or year > END_YEAR) {
            return "+8618680899080";
        }
        
        // 计算农历日期
        var lunarInfo = getLunarDate(year, month, day);
        if (lunarInfo[0] == 0) {
            return "+8618680899080";
        }
        
        var lunarYear = lunarInfo[0];
        var lunarMonth = lunarInfo[1];
        var lunarDay = lunarInfo[2];
        var isLeap = lunarInfo[3];
        
        // 计算天干地支
        var ganzhiYear = getGanzhiYear(lunarYear);
        
        // 构建农历月份字符串
        var monthStr = LUNAR_MONTHS[lunarMonth - 1];
        if (isLeap == 1) {
            monthStr = "闰" + monthStr;
        }
        
        // 构建农历日期字符串
        var dayStr;
        if (lunarDay >= 1 and lunarDay <= LUNAR_DAYS.size()) {
            dayStr = LUNAR_DAYS[lunarDay - 1];
        } else {
            dayStr = "00";
        }
        
        // 计算节气信息
        var solarTermInfo = getSolarTermInfo(year, month, day);
        var solarTermStr = "";
        if (solarTermInfo != null) {
            var days = solarTermInfo[0];
            var term = solarTermInfo[1];
            if (days == 0) {
                solarTermStr = term;
            } else {
                solarTermStr = "+" + days + term;
            }
        }
        
        // 组合最终字符串
        var result = ganzhiYear + "年 " + monthStr + dayStr;
        if (solarTermStr.length() > 0) {
            result += " " + solarTermStr;
        }
        
        return result;
    }
    
    // 获取天干地支年份
    private function getGanzhiYear(year as Number) as String {
        // 以1900年为基准，1900年是庚子年
        var baseYear = 1900;
        var offset = year - baseYear;
        
        // 计算天干索引，确保为正数
        var tianGanIndex = (offset + 6) % 10;
        if (tianGanIndex < 0) {
            tianGanIndex += 10;
        }
        
        // 计算地支索引，确保为正数
        var diZhiIndex = offset % 12;
        if (diZhiIndex < 0) {
            diZhiIndex += 12;
        }
        
        return TIANGAN[tianGanIndex] + DIZHI[diZhiIndex];
    }
    
    // 检查是否是闰年
    private function isLeapYear(year as Number) as Boolean {
        if (year % 400 == 0) {
            return true;
        }
        if (year % 100 == 0) {
            return false;
        }
        if (year % 4 == 0) {
            return true;
        }
        return false;
    }
    
    // 将日期转换为绝对天数（相对于START_YEAR年1月1日）
    private function getDayCount(year, month, day) {
        var days = 0;
        
        // 计算从START_YEAR到当前年份前一年的总天数
        for (var y = START_YEAR; y < year; y++) {
            days += isLeapYear(y) ? 366 : 365;
        }
        
        // 计算当前年份到当前月份的天数
        var monthDays = [0, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
        days += monthDays[month];
        
        // 闰年修正
        if (isLeapYear(year) && month > 2) {
            days += 1;
        }
        
        days += day - 1; // 因为1月1日是第0天
        return days;
    }

    // 返回值: [农历年份, 农历月份, 农历日期, 是否闰月]
    private function getLunarDate(year as Number, month as Number, day as Number) as Array<Number> {
        if (year < START_YEAR || year > END_YEAR) {
            return [0, 0, 0, 0];
        }
        var leapSize = LEAP_MONTH_OFFSETS.size();
        var lunarSize = LUNAR_OFFSET_DAYS.size();
        var baseMonthIdx = 0; // 农历月份索引
        var leapCount = 0;    // 当前月份前的闰月总数
        var isLeap = 0;       // 当前月是否闰月

        // 计算目标日期相对START_YEAR-01-01的天数
        var targetDays = getDayCount(year, month, day);
        if (targetDays < LUNAR_OFFSET_DAYS[0] || targetDays > LUNAR_OFFSET_DAYS[lunarSize - 1] + 30) {
            return [0, 0, 0, 0];
        } else if (targetDays >= LUNAR_OFFSET_DAYS[lunarSize - 1] && targetDays <= LUNAR_OFFSET_DAYS[lunarSize - 1] + 30) {
            baseMonthIdx = lunarSize - 1;
        } else {
            for(var i = 0; i < lunarSize; i++) {
                if (LUNAR_OFFSET_DAYS[i] > targetDays) {
                    baseMonthIdx = i - 1;
                    break;
                }
            }
        }

        if (baseMonthIdx == 0) {    
            return [0, 0, 0, 0];
        }   

        // 计算当前月份前的闰月总数以及是否为闰月
        if (LEAP_MONTH_OFFSETS[0] <= baseMonthIdx) {
            for(var i = 0; i < leapSize; i++) {
                if (LEAP_MONTH_OFFSETS[i] < baseMonthIdx) {
                    leapCount += 1;
                } else if (LEAP_MONTH_OFFSETS[i] == baseMonthIdx) {
                    leapCount += 1;
                    isLeap = 1;
                    break;
                } else {
                    break;
                }
            }
        }

        var realMonthOffset = baseMonthIdx - leapCount;
        var lunarYear = START_YEAR + Math.floor(realMonthOffset / 12);
        var lunarMonth = realMonthOffset % 12 + 1;
        var lunarDay = targetDays - LUNAR_OFFSET_DAYS[baseMonthIdx] + 1;

        return [lunarYear, lunarMonth, lunarDay, isLeap];
    }
    
    // 获取节气信息 [days, term]
    private function getSolarTermInfo(year as Number, month as Number, day as Number) as Array<Object> {
        if (year < START_YEAR or year > END_YEAR) {
            return [0, ""];
        }  
        
        // 计算当前日期相对于START_YEAR年1月1日的天数偏移
        var days = getDayCount(year, month, day);
        
        // 查找下一个节气
        for (var i = 0; i < SOLAR_TERMS_OFFSETS.size(); i++) {
            if (SOLAR_TERMS_OFFSETS[i] == days) {
                // 当天是节气
                return [0, SOLAR_TERMS[i % 24]];
            } else if (SOLAR_TERMS_OFFSETS[i] > days) {
                // 找到下一个节气
                var daysToTerm = SOLAR_TERMS_OFFSETS[i] - days;
                return [daysToTerm, SOLAR_TERMS[i % 24]];
            }
        }
        
        // 如果没有找到下一个节气
        return [0, ""];
    }
}