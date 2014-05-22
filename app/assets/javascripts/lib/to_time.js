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

Date.prototype.toMMDDYYYY = function(){
    var yyyy = this.getFullYear();
    var mm = this.getMonth();
    var dd = this.getDate();
    console.log(yyyy);
    console.log(mm);
    console.log(dd);
    var res = (mm < 10 ? ('0' + mm) : mm) + '/' + (dd < 10 ? ('0' + dd) : dd) + '/' + yyyy;
    return res;
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

String.prototype.fromHHMM = function(date){
    var yyyy = date.getFullYear();
    var mm = date.getMonth();
    var dd = date.getDate();

    var time = this.split(":");
    var h = time[0];
    var m = time[1];

    return new Date(yyyy,mm,dd,h,m,0);
};

String.prototype.fromYYMMDD = function(){
    var yy = this.split('/')[0];
    var mm = this.split('/')[1];
    var dd = this.split('/')[2];
    return new Date(yy,mm,dd,0,0,0);
};

