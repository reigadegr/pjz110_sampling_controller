#!/system/bin/sh
# Copyright 2023 shadow3aaa@gitbub.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

MODDIR=${0%/*}
DIR=/sdcard/Android/fas-rs
LOG=$MODDIR/log.txt

#进入games.toml中指定的APP设置的采样率
games_sampling_rate=240
#日常全局采样率
default_sampling_rate=120

#改完后，重新执行本sh生效

wait_until_login() {
    # in case of /data encryption is disabled
    while [ "$(getprop sys.boot_completed)" != "1" ]; do sleep 1; done
    # we doesn't have the permission to rw "/sdcard" before the user unlocks the screen
    until [ -d /sdcard/Android ]; do sleep 1; done
}

if [ -f $DIR/games.toml ]; then
    File=$DIR/games.toml
else
    File=${0%/*}/games.toml
fi

wait_until_login
killall -15 PJZ110_sampling_controller; rm $LOG
chmod +x ${0%/*}/PJZ110_sampling_controller
RUST_BACKTRACE=1 nohup $MODDIR/PJZ110_sampling_controller $File $games_sampling_rate $default_sampling_rate >$LOG 2>&1 &
