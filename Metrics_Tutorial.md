# Prometheus & Grafana ����͸� �ǽ�


## �ӽ� ���� ����͸�

���θ��׿콺���� �ӽ� ���� ����͸� �� node_exporter ����Ͽ� ���� ���� ������ cpu, �޸�, ��ũ ������ ���� ��ǥ�� ������ �� �ִ�.

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

���� ��� local �ӽſ��� ������ �־, cpu�� ���� �ھ� i7 12700F �� �ھ� ���� 12��, �� ������ ���� 20�� �̴�.
�׷����� ���� 0������ 19�������� �ھ Ȯ���� �� �ִ�. (������ ��?)

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


## ����

���θ��׿콺���� target �����͸� �����ϴ� �ֱ��� scrap time�� �����Ѵ�.

default ���� 1minute�̸�, `prometheus.yml` ���Ͽ��� scrap_interval �� �����ϸ� �Ǵµ�, 

�ʹ� ª�� (ex. 1ms) �����ϸ� ������ �߻��� �� �ִ�.