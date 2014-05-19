Number.prototype.to_time = function() {
    var js_date = new Date(this * 1000);
    return (js_date.getHours() + ':' + js_date.getMinutes());
};

Number.prototype.to_count_of_hours = function() {

    var all_secs = Math.round(this/1000);

    var hours = Math.floor(all_secs/3600);
    var minutes = Math.floor((all_secs - hours*3600)/60);
    var secs = all_secs - hours*3600 - minutes*60;
    var result = '';

    if (hours != 0) result += hours + 'h ';
    if (minutes != 0) result += minutes + 'min';
    if (hours == 0 && minutes == 0 && secs != 0) result += secs + 'sec';
    if (hours == 0 && minutes == 0 && secs == 0) result = '0min';

    return result

};