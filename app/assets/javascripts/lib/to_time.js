Number.prototype.hours_minutes_secs = function(){
    var all_secs = Math.round(this/1000);

    var hours = Math.floor(all_secs/3600);
    var minutes = Math.floor((all_secs - hours*3600)/60);
    var secs = all_secs - hours*3600 - minutes*60;
    var result = {hours: hours, minutes: minutes, secs: secs};

    return result
};

window.toHHMMSS = function(duration) {
    var h = duration.hours();
    var m = duration.minutes();
    var s = duration.seconds();
    var res = '';

    if (h!=0 && h<10) res+='0';
    if (h!=0) res+=h+':';

    if (m!=0 && m<10) res+='0';
    if (m!=0) res+=m+':';
    else if (h!=0) res+='00:';

    if (s<10 && (m!=0 || h !=0)) res+='0';
    res+=s;

    if (h==0 && m==0 ) res+=' sec';
    if (h==0 && m!=0 ) res+=' min';

    return res
};

Number.prototype.toHHMMSS = function() {

    var hash = this.hours_minutes_secs();
    var h = hash.hours;
    var m = hash.minutes;
    var s = hash.secs;
    var res = '';

    if (h!=0 && h<10) res+='0';
    if (h!=0) res+=h+':';

    if (m!=0 && m<10) res+='0';
    if (m!=0) res+=m+':';
    else if (h!=0) res+='00:';

    if (s<10 && (m!=0 || h !=0)) res+='0';
    res+=s;

    if (h==0 && m==0 ) res+=' sec';
    if (h==0 && m!=0 ) res+=' min';

    return res

};

