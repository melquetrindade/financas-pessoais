import 'package:financas_pessoais/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  final double receita = 500.00;
  final double despesa = -2584.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundClaro,
      appBar: AppBar(
          backgroundColor: AppColors.azulPrimario,
          centerTitle: true,
          title: Text(
            "Limites de gastos",
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
          iconTheme: IconThemeData(color: Colors.white),),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              AspectRatio(
      aspectRatio: 1.5,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          maxY: 3000,
          minY: -3000,
          baselineY: 0, // Linha de referência no eixo X
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getBottomTitles,
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false, // Oculta as linhas verticais
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) {
              if (value == 0) {
                return FlLine(
                  color: Colors.grey.shade400,
                  strokeWidth: 1,
                );
              }
              return FlLine(color: Colors.transparent); // Oculta outras linhas
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: receita,
                  color: Colors.green,
                  width: 40,
                  borderRadius: BorderRadius.circular(0),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: despesa,
                  color: Colors.red,
                  width: 40,
                  borderRadius: BorderRadius.circular(0),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  height: 200,
                  width: 200,
                  color: Colors.green,
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  
  Widget getBottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    switch (value.toInt()) {
      case 0:
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text('receitas', style: style, textAlign: TextAlign.center),
        );
      case 1:
        return SideTitleWidget(
          axisSide: meta.axisSide,
          child: Text('despesas', style: style, textAlign: TextAlign.center),
        );
      default:
        return Container();
    }
  }
}