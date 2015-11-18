CFHost API

以下内容来自apple 的CFNetwork编程指南利用 CFHost API 可以获取主机信息,包括主机名、地址以及可达性等信息。这种获取有关主机的信息的过程叫做解析。
CFHost 的用法基本类似于 CFStream:
▪ 创建⼀一个 CFHost 对象。
▪ 开始解析 CFHost 对象。
▪ 获取地址、主机名称或者可达性等信息。
▪ 在完成所有任务之后销毁 CFHost 对象。
就像所有 CFNetwork 类一样,CFHost 同时兼容于 IPv4 和 IPv6。利用 CFHost,你写的代码可以完全透明的处理 IPv4 和 IPv6 。
CFHost 与 CFNetwork 的其他部分结合的非常紧密。比如,有⼀一个 CFStream 的函数叫做 CFStreamCreatePairWithSocketToCFHost ,它可以直接利用 CFHost 对象创建 CFStream 对象。更多有关CFHost 对象函数的内容,请参考 CFHost 参考。
