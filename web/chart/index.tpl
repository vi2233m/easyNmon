<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<title>服务器性能监控报告</title>
		<!-- 引入 echarts.js -->
		<script src="/chart/js/echarts.min.js"></script>
	</head>
	<body>
		<!-- 为ECharts准备一个具备大小（宽高）的Dom -->
		<div id="cpu" style="padding:1px;float:left;width:49%;height:400px;"></div>
		<div id="mem" style="padding:1px;float:left;width:49%;height:400px;"></div>
		<div id="net" style="padding:1px;float:left;width:49%;height:400px;"></div>
		<div id="disk" style="padding:1px;float:left;width:49%;height:400px;"></div>
		<script type="text/javascript">
			// 基于准备好的dom，初始化echarts实例
			var cpuChart = echarts.init(document.getElementById('cpu'));
			var memChart = echarts.init(document.getElementById('mem'));
			var netChart = echarts.init(document.getElementById('net'));
			var diskChart = echarts.init(document.getElementById('disk'));
			//变量定义
			var script="{{.ScriptName}}";//场景脚本
			var xAxisdata=[{{ range .XAxisdatas }}"{{- . }}",{{ end -}}];
			var cpuUser={{.CPUUsers}};
			var cpuSys={{.CPUSyss}};
			var cpuWait={{.CPUWaits}};
			var memfree={{.Memfrees}};
			var active={{.Actives}};
			var memtotal={{.Memtotals}};
			var NetRead={{.NetReads}};
			var NetWrite={{.NetWrites}};
			var DiskRead={{.DiskReads}};
			var DiskWrite={{.DiskWrites}};
//////////////////////// CPU
			var CPU = {
				backgroundColor:"#F2F8FF",
				title: {
					top:'15',x: 'center',
					text: script+'-CPU总体占用情况'
				},
				tooltip: {
			        trigger: 'axis',
			        axisPointer: {
			            animation: false
			        }
			    },
				legend: {
					top:'45',x: 'center',
					data: ['User%', 'Sys%', 'Wait%']
				},
				grid: {
					top:'20%',left: '5%',right: '10%',bottom: '10%',
					containLabel: true
				},
				toolbox: {
					right: '6%',
					feature: {
						saveAsImage: { pixelRatio: 2}
					}
				},
				xAxis: {
					type: 'category',
					boundaryGap: false,
					data: xAxisdata
				},
				yAxis: { type: 'value' },
				series: [{
						name: 'User%',
						type: 'line',
						stack: '总量',
						itemStyle: {
							normal: {
								color: '#006699'
							}
						},
						areaStyle: {normal: {}},
						data: cpuUser,
						markLine : {
							symbol : 'none',
							itemStyle : {
							normal : {
							color:'#1e90ff',
							label : {
								show:true
							}
						}
						},
							data : [{type : 'average', name: 'user平均值'}]
					       	}					       
					},
					{
						name: 'Sys%',
						stack: '总量',
						type: 'line',
						itemStyle: {
							normal: {
								color: '#66CC99'
							}
						},
						areaStyle: {normal: {}},
						data: cpuSys
					},
					{
						name: 'Wait%',
						type: 'line',
						itemStyle: {
							normal: {
								color: '#CC3333'
							}
						},
						areaStyle: {normal: {}},
						data: cpuWait
					}
				]
			};

//////////////////////// MEM
			var MEM = {
				backgroundColor:"#F2F8FF",
				title: {
					top:'15',x: 'center',
					text: script+'-内存使用情况'
				},
				tooltip: {
			        trigger: 'axis',
			        axisPointer: {
			            animation: false
			        }
			    },
				legend: {
					top:'45',x: 'center',
					data: ['memtotal MB','memfree MB','active MB']
				},
				toolbox: {
					right: '6%',
					feature: {
						saveAsImage: { pixelRatio: 2}
					}
				},
				grid: {
					top:'20%',left: '5%',right: '10%',bottom: '10%',
					containLabel: true
				},
				xAxis: [{
					type: 'category',
					boundaryGap: false,
					data: xAxisdata
				}],
				yAxis: { type: 'value' },
				series: [{			
						name: 'memfree MB',
						type: 'line',
						itemStyle: {
							normal: {
								color: '#0099CC'
							}
						},
						data: memfree
					}, {
						name: 'memtotal MB',
						type: 'line',
						itemStyle: {
							normal: {
								color: '#CC3333'
							}
						},
						data: memtotal,
						markLine : {
							symbol : 'none',
							itemStyle : {
							normal : {
							color:'#1e90ff',
							label : {
								show:true
							}
						}
						},
						data : [{type : 'average', name: 'user平均值'}]
						}					       
					}
						, {
							name: 'active MB',
								      type: 'line',
								      itemStyle: {
						normal: {
						color: '#88FF33'
					}
					      },
					        data: active,
					        markLine : {
				                symbol : 'none',
					        itemStyle : {
						normal : {
		 				color:'#0090ff',
		       				label : {
			       			show:true
		       				}
					 }
				       },
					data : [{type : 'average', name: 'user平均值'}]
					 }                                              
					}
					]
			};
			
//////////////////////// NET		
			var NET = {
				backgroundColor:"#F2F8FF",
				title: {
					top:'15',x: 'center',
					text: script+'-网络带宽占用情况'
				},
				tooltip: {
			        trigger: 'axis',
			        axisPointer: {
			            animation: false
			        }
			    },
				legend: {
					top:'45',x: 'center',
					data: ['Total-Read KB/s', 'Total-Write KB/s']
				},
				grid: {
					top:'20%',left: '5%',right: '10%',bottom: '10%',
					containLabel: true
				},
				toolbox: {
					right: '6%',
					feature: {
						saveAsImage: { pixelRatio: 2}
					}
				},
				xAxis: {
					type: 'category',
					boundaryGap: false,
					data: xAxisdata
				},
				yAxis: { type: 'value' },
				series: [{
						name: 'Total-Read KB/s',
						type: 'line',
						areaStyle: {normal: {}},
						data: NetRead,
						markLine : {
							symbol : 'none',
							itemStyle : {
							normal : {
							color:'#1e90ff',
							label : {
								show:true
							}
						}
						},
						data : [{type : 'average', name: 'user平均值'}]
						}					       
					},
					{
						name: 'Total-Write KB/s',
						type: 'line',
						areaStyle: {normal: {}},
						data: NetWrite,
						markLine : {
							symbol : 'none',
							itemStyle : {
							normal : {
							color:'#1e90ff',
							label : {
								show:true
							}
						}
						},
						data : [{type : 'average', name: 'user平均值'}]
					    }					       
					}
				]
			};
			
//////////////////////// DISK		
			var DISK = {
				backgroundColor: "#F2F8FF",
				title: {
					top:'15',x: 'center',
					text: script + '-磁盘IO及读写速率'
				},
				tooltip: {
					trigger: 'axis',
					axisPointer: {
						animation: false
					}
				},
				legend: {
					top:'45',x: 'center',
					data: ['DiskRead KB/s', 'DiskWrite KB/s', 'IO/sec']
				},
				grid: {
					top:'20%',left: '5%',right: '10%',bottom: '10%',
					containLabel: true
				},
				toolbox: {
					right: '6%',
					feature: {
						saveAsImage: {
							pixelRatio: 2
						} 
					}
				},				
				xAxis: {
					type: 'category',
					boundaryGap: false,
					data: xAxisdata
				},
				yAxis: { type: 'value' },
				series: [{
						name: 'DiskRead KB/s',
						type: 'line',
						itemStyle: {
							normal: {
								color: '#FF9966'
							}
						},
						areaStyle: {normal: {}},
						data: DiskRead,
						markLine : {
							symbol : 'none',
							itemStyle : {
							normal : {
							color:'#1e90ff',
							label : {
								show:true
							}
						}
						},
						data : [{type : 'average', name: 'user平均值'}]
						}					       
					},
					{
						name: 'DiskWrite KB/s',
						type: 'line',
						itemStyle: {
							normal: {
								color: '#6699CC'
							}
						},
						areaStyle: {normal: {}},
						data: DiskWrite,
						markLine : {
							symbol : 'none',
							itemStyle : {
							normal : {
							color:'#1e90ff',
							label : {
								show:true
							}
						}
						},
						data : [{type : 'average', name: 'user平均值'}]
						}					       
					}
				]
			};


			cpuChart.setOption(CPU);
			memChart.setOption(MEM);
			netChart.setOption(NET);
			diskChart.setOption(DISK);
		</script>
	</body>

</html>
