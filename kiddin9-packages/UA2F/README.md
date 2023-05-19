![UA2F](https://socialify.git.ci/Zxilly/UA2F/image?description=1&descriptionEditable=Change%20User-agent%20to%20F-words%20on%20OpenWRT%20router.&font=Inter&language=1&pattern=Plus&stargazers=1&theme=Light)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FZxilly%2FUA2F.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2FZxilly%2FUA2F?ref=badge_shield)

暂时来说，懒得写 README，请先参照 [博客文章](https://learningman.top/archives/304) 完成操作

如果遇到了任何问题，欢迎提出 Issues，但是更欢迎直接提交 Pull Request

> 由于新加入的 CONNMARK 影响，编译内核时需要添加 `NETFILTER_NETLINK_GLUE_CT` flag

# uci command

```bash
# 启用 UA2F
uci set ua2f.enabled.enabled=1

# 可选的防火墙配置选项
# 是否自动添加防火墙规则
uci set ua2f.firewall.handle_fw=1

# 是否尝试处理 443 端口的流量， 通常来说，流经 443 端口的流量是加密的，因此无需处理
uci set ua2f.firewall.handle_tls=1

# 是否处理微信的流量，微信的流量通常是加密的，因此无需处理。这一规则在启用 nftables 时无效
uci set ua2f.firewall.handle_mmtls=1

# 是否处理内网流量，如果你的路由器是在内网中，且你想要处理内网中的流量，那么请启用这一选项
uci set ua2f.firewall.handle_intranet=1

# 应用配置
uci commit ua2f

# 开机自启
service ua2f enable

# 启动 UA2F
service ua2f start
```

# 自定义 User-Agent

如果想自定义 User-Agent， 当前可以修改代码中的 `/src/custom.h`，取消 `#define UA2F_CUSTOM_UA` 的注释，然后修改 `UA2F_CUSTOM_UA` 的值即可。

UA2F_CUSTOM_UA 的值必须是一个字符串，且长度不超过 `(65535 + (MNL_SOCKET_BUFFER_SIZE / 2))` 字节。 MNL_SOCKET_BUFFER_SIZE 的值通常为 8192。

UA2F 不会修改包的大小，因此即使自定义了 User-Agent， 运行时实际的 User-Agent 会是一个从 custom ua 中截取的长度与原始 User-Agent 相同的子串。

## TODO

- [ ] pthread 支持，由不同线程完成入队出队
- [ ] 清除 TCP Header 中的 timestamp，有论文认为这可以被用来识别 NAT 后的多设备，劫持 NTP 服务器并不一定有效


## License
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FZxilly%2FUA2F.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2FZxilly%2FUA2F?ref=badge_large)
