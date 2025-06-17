import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'weight_provider.dart';
import 'weight_model.dart';

class StatistikPage extends StatefulWidget {
  @override
  _StatistikPageState createState() => _StatistikPageState();
}

class _StatistikPageState extends State<StatistikPage> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<WeightProvider>(context, listen: false).loadWeights();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('Statistik Berat Badan'),
          backgroundColor: Colors.teal,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.show_chart), text: 'Grafik'),
              Tab(icon: Icon(Icons.list), text: 'Data'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
        ),
        body: Consumer<WeightProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                ),
              );
            }
            
            if (provider.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      provider.error!,
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _loadData,
                      child: Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }
            
            if (provider.weights.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tidak ada data berat badan',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _loadData,
                      child: Text('Muat Data'),
                    ),
                  ],
                ),
              );
            }

            return TabBarView(
              controller: _tabController,
              children: [
                _buildChartTab(provider),
                _buildDataTab(provider),
              ],
            );
          },
        ),
      );
    }

  Widget _buildChartTab(WeightProvider provider) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _buildLineChart(provider),
          SizedBox(height: 20),
          _buildStatsSummary(provider),
          SizedBox(height: 20),
          _buildBarChart(provider),
        ],
      ),
    );
  }

  Widget _buildDataTab(WeightProvider provider) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: provider.weights.length,
      itemBuilder: (context, index) {
        final record = provider.weights[index];
        return _buildWeightCard(record, index, provider);
      },
    );
  }

 Widget _buildLineChart(WeightProvider provider) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Perkembangan Berat Badan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (provider.weights.length - 1).toDouble(),
                minY: provider.minWeight - 5,
                maxY: provider.maxWeight + 5,
                lineTouchData: LineTouchData(enabled: true),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 5,
                  verticalInterval: 1,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < provider.weights.length && index % 2 == 0) {
                          return Text(
                            provider.weights[index].formattedDate,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 10,
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()} kg',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey[300]!),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: provider.weights.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value.weight,
                      );
                    }).toList(),
                    isCurved: true,
                    color: Colors.teal,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.teal.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildStatsSummary(WeightProvider provider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatisticRow(
              'Rata-rata',
              '${provider.averageWeight.toStringAsFixed(1)} kg',
              Icons.calculate,
              Colors.blue,
            ),
            Divider(height: 24, thickness: 1, color: Colors.grey[200]),
            _buildStatisticRow(
              'Terendah',
              '${provider.minWeight.toStringAsFixed(1)} kg',
              Icons.arrow_downward,
              Colors.green,
            ),
            Divider(height: 24, thickness: 1, color: Colors.grey[200]),
            _buildStatisticRow(
              'Tertinggi',
              '${provider.maxWeight.toStringAsFixed(1)} kg',
              Icons.arrow_upward,
              Colors.red,
            ),
            Divider(height: 24, thickness: 1, color: Colors.grey[200]),
            _buildStatisticRow(
              'Variasi',
              '${provider.weightVariation.toStringAsFixed(1)} kg',
              Icons.compare,
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }
Widget _buildBarChart(WeightProvider provider) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distribusi Berat Badan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                minY: 0,
                maxY: provider.maxWeight + 10,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0: return Text('Min');
                          case 1: return Text('Rata2');
                          case 2: return Text('Max');
                          default: return Text('');
                        }
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()} kg');
                      },
                      reservedSize: 28,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: provider.minWeight,
                        color: Colors.green,
                        width: 24,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: provider.averageWeight,
                        color: Colors.blue,
                        width: 24,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: provider.maxWeight,
                        color: Colors.red,
                        width: 24,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildWeightCard(WeightRecord record, int index, WeightProvider provider) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal[100],
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: Colors.teal[800],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          '${record.weight} kg',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.teal[800],
          ),
        ),
        subtitle: Text(
          DateFormat('EEEE, d MMMM y', 'id_ID').format(record.date),
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: _buildTrendIcon(index, provider),
      ),
    );
  }

  Widget _buildTrendIcon(int index, WeightProvider provider) {
    if (index == 0) {
      return Icon(Icons.horizontal_rule, color: Colors.grey);
    }

    final current = provider.weights[index].weight;
    final previous = provider.weights[index - 1].weight;

    if (current > previous) {
      return Icon(Icons.trending_up, color: Colors.red[700]);
    } else if (current < previous) {
      return Icon(Icons.trending_down, color: Colors.green[700]);
    } else {
      return Icon(Icons.trending_flat, color: Colors.blue[700]);
    }
  }

  Widget _buildStatisticRow(String title, String value, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
            ],
          ),
          Spacer(),
          Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}