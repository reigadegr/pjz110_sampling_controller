use regex::Regex;
use std::time::Duration;
use std::{env, fs, process, thread};
mod utils;
use crate::utils::get_top_app::get_topapp_pid_and_name;
use anyhow::Result;
fn main() -> Result<()> {
    // 从文件中读取TOML内容
    let self_pid = process::id();
    let _ = fs::write("/dev/cpuset/background/cgroup.procs", self_pid.to_string());
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("参数数量小于2，请提供至少一个参数。");
        return Ok(());
    }
    let rs = read_file(args[1].clone());
    if rs.is_err() {
        println!("出错啦读取文件");
    }
    Ok(())
}

fn read_file(file: String) -> Result<()> {
    let config_str = fs::read_to_string(file)?;
    let re = Regex::new(r#""(.*?)""#)?;

    // 找到所有匹配的内容
    let matches = re.find_iter(&config_str);

    // 打印所有匹配的内容
    for mat in matches {
        println!("{}", mat.as_str());
    }
    Ok(())
}
fn run() -> Result<()> {
    let global_package = "".to_string();
    loop {
        let (pid, name) = get_topapp_pid_and_name()?;

        if global_package == name {
            thread::sleep(Duration::from_millis(1000));
            continue;
        }
    }
}
