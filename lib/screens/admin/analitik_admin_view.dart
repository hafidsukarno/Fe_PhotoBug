import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalitikAdminView extends StatefulWidget {
  final double topPadding;

  const AnalitikAdminView({super.key, required this.topPadding});

  @override
  State<AnalitikAdminView> createState() => _AnalitikAdminViewState();
}

class _AnalitikAdminViewState extends State<AnalitikAdminView> {
  // 0 = 1bln, 1 = 3bln, 2 = 6bln
  int _selectedPeriod = 2; 

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Row of Stat Cards
                _buildStatCards(),
                const SizedBox(height: 20),

                // Chart 1: Tren Hama
                _buildTrenHamaChart(),
                const SizedBox(height: 20),

                // Chart 2: Distribusi Jenis Hama
                _buildDistribusiHamaChart(),
                const SizedBox(height: 20),

                // Chart 3: Desa Terbanyak
                _buildDesaTerbanyakList(),
                const SizedBox(height: 32),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ==================== HEADER & PERIOD FILTER ====================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, widget.topPadding + 20, 24, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4A148C), Color(0xFF7B1FA2)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x334A148C),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Analitik',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Visualisasi tren hama & kinerja sistem',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              
              // Period Selector Row
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildPeriodBtn(0, '1bln'),
                    _buildPeriodBtn(1, '3bln'),
                    _buildPeriodBtn(2, '6bln'),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodBtn(int index, String label) {
    final isSelected = _selectedPeriod == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: isSelected ? const Color(0xFF7B1FA2) : Colors.white,
          ),
        ),
      ),
    );
  }

  // ==================== STAT CARDS ====================
  Widget _buildStatCards() {
    return Row(
      children: [
        Expanded(
          child: _buildCardItem(
            icon: Icons.trending_up_rounded,
            value: '41',
            label: 'Laporan/bln',
            color: const Color(0xFF7B1FA2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCardItem(
            icon: Icons.calendar_month_rounded,
            value: '3.2',
            label: 'Respons (jam)',
            color: const Color(0xFF1565C0),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCardItem(
            icon: Icons.workspace_premium_rounded,
            value: '91%',
            label: 'Akurasi AI',
            color: const Color(0xFF2E7D32),
          ),
        ),
      ],
    );
  }

  Widget _buildCardItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== CHART 1: TREN HAMA ====================
  Widget _buildTrenHamaChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tren Hama 6 Bulan Terakhir',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 24),
          
          // The line chart using fl_chart
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 9,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 9,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.bold),
                        );
                      },
                      reservedSize: 28,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 24,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun'];
                        if (value >= 0 && value < months.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              months[value.toInt()],
                              style: TextStyle(color: Colors.grey.shade400, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 36,
                lineBarsData: [
                  // Wereng Coklat (Dark Green)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 18),
                      FlSpot(1, 24),
                      FlSpot(2, 20),
                      FlSpot(3, 36),
                      FlSpot(4, 29),
                      FlSpot(5, 33),
                    ],
                    isCurved: true,
                    color: const Color(0xFF1B5E20),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF1B5E20).withValues(alpha: 0.05),
                    ),
                  ),
                  // Wereng Hijau (Teal/Light Green)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 10),
                      FlSpot(1, 14),
                      FlSpot(2, 12),
                      FlSpot(3, 20),
                      FlSpot(4, 17),
                      FlSpot(5, 22),
                    ],
                    isCurved: true,
                    color: const Color(0xFF00BFA5),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: const Color(0xFF00BFA5).withValues(alpha: 0.05),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Legend Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Wereng Coklat', const Color(0xFF1B5E20)),
              const SizedBox(width: 24),
              _buildLegendItem('Wereng Hijau', const Color(0xFF00BFA5)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ==================== CHART 2: DISTRIBUSI JENIS HAMA ====================
  Widget _buildDistribusiHamaChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribusi Jenis Hama',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              // Donut Chart
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 140,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          color: const Color(0xFF1B5E20),
                          value: 65,
                          title: '',
                          radius: 20,
                        ),
                        PieChartSectionData(
                          color: const Color(0xFF00BFA5),
                          value: 35,
                          title: '',
                          radius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Legend
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _buildPieLegendRow('Wereng Coklat', '65%', const Color(0xFF1B5E20)),
                    const SizedBox(height: 12),
                    _buildPieLegendRow('Wereng Hijau', '35%', const Color(0xFF00BFA5)),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPieLegendRow(String label, String pct, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
        Text(
          pct,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }

  // ==================== CHART 3: DESA TERBANYAK LIST ====================
  Widget _buildDesaTerbanyakList() {
    final List<Map<String, dynamic>> desaRank = [
      {'nama': 'Ds. Sukamaju', 'count': 12, 'percentage': 1.0},
      {'nama': 'Ds. Ciawi Lor', 'count': 8, 'percentage': 0.66},
      {'nama': 'Ds. Rawa Gede', 'count': 5, 'percentage': 0.41},
      {'nama': 'Ds. Sindangjaya', 'count': 2, 'percentage': 0.16},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Desa dengan Laporan Terbanyak',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 20),

          ...List.generate(desaRank.length, (index) {
            final item = desaRank[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  // Rank number bubble
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B1FA2).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF7B1FA2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Village Name
                  Expanded(
                    flex: 4,
                    child: Text(
                      item['nama'],
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                  ),

                  // Progress Bar
                  Expanded(
                    flex: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: item['percentage'],
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade100,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF9C27B0)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Count value
                  SizedBox(
                    width: 20,
                    child: Text(
                      '${item['count']}',
                      textAlign: metaTextAlign(index),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF7B1FA2),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  TextAlign metaTextAlign(int index) {
    return TextAlign.end;
  }
}
