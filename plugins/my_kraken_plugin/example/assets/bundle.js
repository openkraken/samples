alarmClock.setTime(5);
alarmClock.onTimeListener = (e, data) => {
    console.log('alarm event', e);
    console.log('alarm data', data);
};