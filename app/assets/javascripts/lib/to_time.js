Number.prototype.toHHMM = function() {
    if (this == 0) return '';
    else {
        var js_date = new Date(this * 1000);
        var res = js_date.getHours() + ':';
        if (js_date.getMinutes() < 10) res += '0';
        return (res + js_date.getMinutes());
    }

};

Date.prototype.toHHMM = function(){
    var h = this.getHours();
    var m = this.getMinutes();
    var res = (h < 10 ? ('0' + h) : h) + ':' + (m < 10 ? ('0' + m) : m);
    return res;
};


Date.prototype.toYYYYMMDD = function(){
    var dd = this.getDate();
    var mm = this.getMonth()+1;
    var yyyy = this.getFullYear();
    if(dd<10){dd='0'+dd} if(mm<10){mm='0'+mm} return dd.toString() + '/' + mm.toString() + '/' + yyyy.toString();
};

Number.prototype.hours_minutes_secs = function(){
    var all_secs = Math.round(this/1000);

    var hours = Math.floor(all_secs/3600);
    var minutes = Math.floor((all_secs - hours*3600)/60);
    var secs = all_secs - hours*3600 - minutes*60;
    var result = {hours: hours, minutes: minutes, secs: secs};

    return result
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

String.prototype.fromHHMM = function(){
    var today = new Date();
    var yyyy = today.getFullYear();
    var mm = today.getMonth();
    var dd = today.getDate();

    var time = this.split(":");
    var h = time[0];
    var m = time[1];

    return new Date(yyyy,mm,dd,h,m,0);
};

