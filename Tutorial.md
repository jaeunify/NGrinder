# Prometheus & Grafana ����͸� �ǽ� Ʃ�丮��

## ����

### [�ӽ� ���� ����͸�](#�ӽ�-����-����͸�)
- [���� �޸� ����](#����-�޸�-����)
- [��� cpu ����](#���-cpu-����)
- [���� cpu ����](#����-cpu-����)
- [��ũ �뷮 ����](#��ũ-�뷮-����)
- [��Ʈ��ũ ����](#��Ʈ��ũ-����)
- [CPU �̿��](#CPU-�̿��)

- 
### [API ������ �ʴ� ��û �� ǥ��](#api-������-�ʴ�-��û-��-ǥ��-1)
- [�ֱ� 1�а� 1�ʸ��� ���� HTTP ��û�� ��� ����](#�ֱ�-1�а�-1�ʸ���-����-HTTP-��û��-���-����)
- [�ֱ� 5�а� ��������Ʈ �� HTTP ��û ��� ó�� �ð�(��)](#�ֱ�-5�а�-��������Ʈ-��-HTTP-��û-���-ó��-�ð�(��))
- [Ư�� API ���� ��û ��](#Ư��-API-����-��û-��)
- [Ư�� API �ʴ� ��û ��](#Ư��-API-�ʴ�-��û-��)
- [ASP.NET core ���� �� Gauge metric�� ���� Ư�� API ����͸��ϱ�](#aspnet-core-��-gauge-metric-Ȱ���ؼ�-Ư��-api-����͸��ϱ�)


### [C#������ GC ����](#GC-����)
- [���ø����̼� �� Garbage Collection �� ���� Ƚ��](#���ø����̼�-��-Garbage-Collection-��-����-Ƚ��)
- [���뺰 GC ���� Ƚ��](#���뺰-GC-����-Ƚ��)
- [���뺰 GC ��� ���� Ƚ��](#���뺰-GC-���-����-Ƚ��)


### [Prometheus ������ with C# asp.net core](#prometheus-������-with-c-aspnet-core-1)
- [Prometheus Metrics type](#prometheus-metrics-type)
- [ASP.NET Core���� Prometheus ����ϱ�](#aspnet-core����-prometheus-����ϱ�)

 
---


## �ӽ� ���� ����͸�

���θ��׿콺���� �ӽ� ���� ����͸� �� node_exporter ����Ͽ� ���� ���� ������ cpu, �޸�, ��ũ ������ ���� ��ǥ�� ������ �� �ִ�.

�Ʒ��� �ӽ� ���¸� ����͸� �ϰ� �⺻������ http ��û�� ó���ϴ� ��� ����̴�.


### ���� �޸� ����

#### ���� ������ �޸� Ȯ��
```bash
free -m
```

#### promql�� ���� Grafana���� ������ �ð�ȭ

1. �����ϰ��ִ� �޸� Ȯ��
```promql
node_memory_Active_bytes / node_memory_MemTotal_bytes
```

2. ������ ���� ������, ��� ������ �޸� Ȯ��
```promql
(1 - (node_memory_Active_bytes / node_memory_MemTotal_bytes)) * 100
```


### ��� cpu ����

```promql
100 - (avg by (cpu) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

cpu ��� ������ ��Ÿ����.
- avg by (cpu) : cpu�� ���� ���
- node_cpu_seconds_total{mode="idle"}[5m] : 5m �� mode�� idle ������ cpu ���� ���
- ��ü - �����ִ� cpu ���� : ���� �̿��

���� ��� local �ӽſ��� ������ �־, cpu�� ���� �ھ� i7 12700F �� �������� �ھ� ���� 12��, �� ������ ���� 20�� �̴�.

�׷����� ���� 0������ 19�������� �ھ Ȯ���� �� �ִ�. (������ ��)

<details>

<summary>������ �ھ� vs ���� �ھ�</summary>

`������ �ھ�`�� `���� �ھ�(������)` �� ������ �ٸ��� ������ 

�� 20���� CPU �׸��� �������� ���̴�.

1. **������ �ھ� vs ���� �ھ� (������)**
   - **������ �ھ�**: ���� CPU ���� �������� ���� ��������, `Intel Core i7 12700F`�� ��� **12���� ������ �ھ�**
   - **���� �ھ�(������)**: �� ������ �ھ ���ÿ� ������ �� �ִ� ���� ���μ��� ����. `Intel Core i7 12700F`�� ��� **Hyper-Threading** ����� �����Ͽ� �� �ھ 2���� �����带 ���� ����
	 + �׷��� �����δ� **12���� ������ �ھ 20���� ���� �ھ�**�� ��Ÿ��

2. **Prometheus�� Node Exporter�� �����ϴ� CPU ������**
   - Prometheus�� `node_cpu_seconds_total` ��Ʈ���� **���� �ھ� ����**�� �����͸� ����
	- ���� �ھ� ���� �� 20���̱� ������ `cpu=0`���� `cpu=19`���� 20���� �ھ ���� ǥ��
   - **�� ���� �ھ�� ���������� ����**
	- Node Exporter�� �̸� ������� �� ���� �ھ��� `idle`, `user`, `system` ��忡���� CPU ��� �ð��� ����

3. **������ ���̴� 20���� CPU �׷���**
   - �ý��ۿ��� **���� �ھ �������� ������**�� �����ϱ� ������ **�� �����帶�� CPU ��뷮**�� ���� ǥ��
	- ���� �ھ��� ��뷮�� ��� ��� ���� �׷����� ǥ���ϴ� ��� CPU ������ ��ü �ý��� ������ ������� ��Ÿ����.
   - ���� ������ �ھ�� 12������ Hyper-Threading�� ���� 20���� ���� �ھ ǥ�õǸ�, **���� �������� ����**�� ���� �� �ִ�.

�̷� ���� ������ �ھ�� ���� ���� �ھ �������� ���� �������� �����Դϴ�.

</details>


### ���� cpu ����

```promql
node_cpu_seconds_total
```

���� cpu ��� �ð��� ��Ÿ����.
- Grafana������ ������ K�� Ȯ�εǾ� 4K = 4000�ʷ� Ȯ���ϸ� �ȴ�.

### ��ũ �뷮 ����

�����쿡���� ��ũ �뷮 ����

```promql
100 - (windows_logical_disk_free_bytes / windows_logical_disk_size_bytes) * 100
```

������������ ��ũ �뷮 ����

```promql
100 - ((node_filesystem_free_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}) * 100)
```

```promql
100 - ((node_filesystem_free_bytes{mountpoint="/mnt/c"} / node_filesystem_size_bytes{mountpoint="/mnt/c"}) * 100)
```

��ũ �뷮 ������ �ǹ� : ��� ���� �뷮�� ��ü ��ũ �뷮 ��� ���ۼ�Ʈ����


### ��Ʈ��ũ ����

- rate �Լ��� 5�� ���� �ʴ� ����Ʈ ���� ����� ��� ��
- bps(bit per second)�� ��ȯ�ϱ� ���� * 8

#### ��Ʈ��ũ ���� �ӵ�

```promql
rate(node_network_transmit_bytes_total{device="eth0"}[5m]) * 8
```

#### ��Ʈ��ũ ���� �ӵ�

```promql
rate(node_network_receive_bytes_total{device="eth0"}[5m]) * 8
```
 
Prometheus�� �� UI���� ��Ʈ��ũ ��ġ �̸��� ��ȸ �� promql ���� �ۼ�����
1. http://localhost:9090 ���� �̵� �� Graph �� Ŭ��
2. Expression�� `node_network_transmit_bytes_total` �Է� �� Execute Ŭ�� �� ��ġ �� Ȯ��

���� ��� `eth0` �� ��ɾ �ۼ��ߴ�.


### CPU �̿��(%)

```promql
100 - (avg by (instance) (irate(windows_cpu_time_total{mode="idle"}[5m])) * 100)
```

```promql
100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

- `windows_cpu_time_total{mode="idle"}` : �ھ� �� CPU ���� �ð� (��ǻ�� ���� �� CPU�� ���� ���� ���� ���� �ð�)
- `irate(windows_cpu_time_total{mode="idle"}[5m])` : �ھ� �� CPU ���� �ð� ����
	
	+ rate() : �־��� �ð��� ���� (���� �� - �־��� �ð���ŭ ���� ��) / (���� �ð� - �־��� �ð���ŭ ���� �ð�)���� ���
	    - ���� �Ŀ��� 5������ �־����ٸ� �ֱ� 5�� �� �� �� �� ������ ���̸� 1�� ������ ��� �� ���̴�.

	+ irate() : (���� �� - �ٷ� ������ ��) / (���� �ð� - �ٷ� ������ �ð�)���� ���
	    - �־��� �ð��� ���� ���� ���� �����Ϳ� ���� �ֱ��� ������ ������ ���̸� 1�� ������ ��� �� ���̴�. 
	    - �־��� �ð� ���� irate�� ����� �� ������ �ð� ������ �ִ����ν� �� ������ ������ �ð� ���ݺ��� ũ�ٸ� � ���̵� ���� ����� ��ȯ�Ѵ�. 
		- �ݴ�� �־��� �ð� ���� �� ������ ������ �ð� ���ݺ��� �۴ٸ� �����Ͱ� ���� ������ �Ǵ��Ѵ�.

	+ rate()�� �׷����� ���Ⱑ �ε巴�� �ٲ�Ƿ� ��ü���� ���� ��ȭ�� �� �� �����ϰ�, 
	  
	+ irate()�� �׷����� ���Ⱑ ���� �ް��ϰ� �ٲ� �� �־� CPU �Ǵ� �޸� ���¿� ���� ª�� �ð� ���� ���� ���ϴ� �� �����ؾ� �� �� ���ȴ�.
 

- `avg by (instance) (irate(windows_cpu_time_total{mode="idle"}[5m]))` : �ν��Ͻ� �� CPU ���� �ð� ���� ���



## ����

���θ��׿콺���� target �����͸� �����ϴ� �ֱ��� scrap time�� �����Ѵ�.

default ���� 1minute�̸�, `prometheus.yml` ���Ͽ��� scrap_interval �� �����ϸ� �Ǵµ�, 

�ʹ� ª�� (ex. 1ms) �����ϸ� ������ �߻��� �� �ִ�.

<br><br>

---

## API ������ �ʴ� ��û �� ǥ��

�̾ API ������ �ʴ� ��û ���� ǥ���ϴ� �� �ڼ��� ��� ����̴�.

endpoint �̸��� ���� ��ȸ�ϴ� ���ú���, Gauge�� ����ϴ� ���� ������ �ٷ�� �ִ�.


### �ֱ� 1�а� 1�ʸ��� ���� HTTP ��û�� ��� ����

```promql
sum by (endpoint) (rate(http_requests_received_total[1m]))
```

- `http_requests_received_total` : HTTP ��û�� ���� ����
- `rate(http_requests_received_total[1m])` : �ֱ� 1�� �� HTTP ��û ���� / 60��

endpoint ���� HTTP ��û �׷����� Ȯ���� �� �ִ�.

### �ֱ� 5�а� ��������Ʈ �� HTTP ��û ��� ó�� �ð�(��)

```promql
avg by (endpoint) (rate(http_request_duration_seconds_sum[5m]) / rate(http_request_duration_seconds_count[5m]))
```

- `http_request_duration_seconds_sum` : HTTP ��û ó�� ���� �ð�
- `rate(http_request_duration_seconds_sum[5m])` : �ֱ� 5�� �� 1�ʸ��� HTTP ��û�� ó���ϴ� �� �Ҹ��� �ð�
- `(rate(http_request_duration_seconds_sum[5m]) / rate(http_request_duration_seconds_count[5m]))` : �ֱ� 5�� �� HTTP ��û�� ��� ó�� �ð�


### Ư�� API ���� ��û ��

Login API�� ���� ��û ���� ��ȸ�ϴ� �����̴�.

```promql
http_requests_received_total{endpoint="Login"}
```

### Ư�� API �ʴ� ��û ��

Login API�� �ʴ� ��û ���� ��ȸ�ϴ� �����̴�.

```promql
rate(http_requests_received_total{endpoint="Login"}[1m])
```

- endpoint�� Login�̸鼭 �ð��� ������ 1m
- 1�а��� ������ ��û ���� ����� �˱� ���� rate �Լ�
- [] ��, �� ������ �ʹ� ª�ٸ� metric�� ������ �� ����.


### ASP.NET core �� Gauge Metric Ȱ���ؼ� Ư�� API ����͸��ϱ�

ASP.net core���� Prometheus�� ����Ͽ� Ư�� API�� ��û ���� ����͸��ϴ� ����̴�. 
nuget���� ��Ű�� ��ġ ���� `using Prometheus;` �� ���� ����� �� �ִ�.

�Ʒ��� FakeLoginController ������ Gauge Metric�� �����ϰ�, FakeLogin API ��û�� ���� ������ ������Ű�� �����̴�.

```csharp

    private static readonly Gauge FakeLoginGauge = Metrics.CreateGauge("game_server_fake_login", "Fake login Metric");

    ...

    [HttpPost]
    public async Task<GameLoginResponse> FakeLogin([FromBody] GameLoginRequest request)
    {
        FakeLoginGauge.Inc();
		...
    }
```

���� ���� �ڵ带 �����ϸ� FakeLogin API ��û�� ���� ������ FakeLoginGauge�� �����ϰ� �ȴ�.

�ش� Endpoint�� metrics�� ��ȸ�غ��� �Ʒ��� ���� ���� ���� Ȯ���� �� �ִ�.


Grafana������ �ش� gauge Metric�� ��ȸ�� �� �ִ�.

```promql
game_server_fake_login
sum(game_server_fake_login)
```


<br><br>

---


## GC ����

### ���ø����̼� �� Garbage Collection �� ���� Ƚ��

```promql
dotnet_collection_count_total
```
- 0����, 1����, 2���� ���� Ƚ�� Ȯ�� ����


### ���뺰 GC ���� Ƚ��

```promql
dotnet_collection_count_total{generation="0"}
```
- generation="0" : 0���� ���� Ƚ��


### ���뺰 GC ��� ���� Ƚ��

```promql
rate(dotnet_collection_count_total[1m])
```

- dotnet_collection_count_total : ��ü gc ���� �� ���� Ƚ��
- rate(dotnet_collection_count_total[1m]) : rate �Լ��� ���� 1�� ���� ��� ���� Ƚ�� Ȯ�� ����


<br><br>

---

# Prometheus ������ (with C# asp.net core)



## Prometheus Metrics type

1. Counter : �����ϴ� ��

2. Gauge : ����, �����ϴ� ��

3. Histogram : ���� ������ ������ ����

4. Summary : Histogram�� ���������� quantile�� ����Ͽ� ���� ������ ����

<br><br>

---

## ASP.NET Core���� Prometheus ����ϱ�

### ASP.NET core ������ ����

- nuget���� "Install-Package prometheus-net.AspNetCore"�� ���� ��Ű���� ��ġ�Ѵ�.
- http request�� ����͸��ϱ� ���� "app.UseRoutin()"���� "app.UseHttpMetrics()"�� "app.UseMetricsServer()"�� �߰��Ѵ�.

### Ư�� http request�� Count�ϱ�

- �⺻������ PromQL "http_request_duration_seconds_count"�� ���� ��� http request�� ����͸� �� �� ������ 
- Ư�� http request���� ����͸� �� �� �ֵ��� Counter ��Ʈ���� ������ �� �ִ�.

- `API_Server_LoginCounter` ������ ����͸� �� �� �ִ�.

### ��Ÿ�� ����͸�
- build, jit, garbage collection(GC), excption, contetion ���� �������� ����͸� �Ѵ�. 
- nuget���� prometheus-net.DotNetRuntime ��Ű���� ��ġ
- Program.cs ���� collector�� �����Ͽ� ����Ѵ�.

	```csharp
	// default
	IDisposable collector = DotNetRuntimeStatsBuilder.Default().StartCollecting();
 
	// ���ϴ� ������ ����͸�
	IDisposable collector = DotNetRuntimeStatsBuilder
		.Customize()
		.WithContentionStats()
		.WithJitStats()
		.WithThreadPoolStats()
		.WithGcStats()
		.WithExceptionStats()
		.StartCollecting();
	```

### ����

- nuget���� "Install-Package prometheus-net"�� ���� ��Ű���� ��ġ�Ѵ�.
- program.cs

	```csharp
	// http://localhost:5002/metrics ���θ��׿콺 ����
	var prometheusServer = new MetricServer(hostname:"127.0.0.1",port: 5002);
	prometheusServer.Start();
	```


- ��Ÿ�� ����͸� : build, jit, garbage collection(GC), excption, contetion ���� ����

	```csharp
	// default
	IDisposable collector = DotNetRuntimeStatsBuilder.Default().StartCollecting();
 
	// ���ϴ� ������ ����͸�
	IDisposable collector = DotNetRuntimeStatsBuilder
		.Customize()
		.WithGcStats()
		.WithContentionStats()
		.WithThreadPoolStats()
		.WithJitStats()
		.WithExceptionStats()
		.WithSocketStats()
	   .StartCollecting();

   ```

### ���� ���ҽ�

- CPU, Memory, Network �� �ϵ���� ������ ����͸�

- Node exporter (linux)

#### CPU Load

```promql
sum by (mode) (rate(windows_cpu_time_total[5m]))
```

#### Memory Usage

```promql
windows_cs_physical_memory_bytes - windows_os_physical_memory_free_bytes
```
#### Network

```promql
rate(windows_net_bytes_sent_total[5m])
```
#### Disk

```promql
rate(windows_logical_disk_split_ios_total{volume !~"HarddiskVolume.+"}[5m])
```
#### GC (DotNet)

```promql
increase(dotnet_collection_count_total[5m])
```
#### CPU usage (DotNet)

```promql
avg by (instance) (irate(process_cpu_seconds_total[5m]))
```
5�� ���� �� �ν��Ͻ��� �ʴ� CPU ��� �ð��� �����Ͽ�, �ν��Ͻ��� ��� CPU ������ ���

#### Network (DotNet)

```promql
rate(dotnet_sockets_bytes_sent_total[5m])

rate(dotnet_sockets_bytes_received_total[5m])
```

#### API Server ����͸� (ASP.NET Core)

```promql
rate(http_request_duration_seconds_count[5m])
```

#### ���� Server ����͸� (.Net Framework)

���� ����� ���� ��

```promql
dotnet_sockets_connections_established_incoming_total
```

#### �ް�/������ Ʈ����

```promql
rate(dotnet_sockets_bytes_sent_total[5m])

rate(dotnet_sockets_bytes_received_total[5m])
```