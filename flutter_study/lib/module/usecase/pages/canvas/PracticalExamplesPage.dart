import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_study/module/usecase/pages/canvas/PracticalExamples.dart';

/// 实用案例展示页面
class PracticalExamplesPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    final animationController = useAnimationController(duration: Duration(seconds: 3))..repeat();

    return Scaffold(
      appBar: AppBar(title: Text('Canvas 实用案例'), backgroundColor: Colors.purple),
      body: Column(
        children: [
          _buildTabBar(selectedIndex),
          Expanded(
            child: Container(
              color: Colors.grey[50],
              padding: EdgeInsets.all(20),
              child: Center(child: _buildContent(selectedIndex.value, animationController)),
            ),
          ),
          _buildDescription(selectedIndex.value),
        ],
      ),
    );
  }

  Widget _buildTabBar(ValueNotifier<int> selectedIndex) {
    final tabs = ['进度圆环', '折线图', '仪表盘', '水波纹', '签名板', '雷达图', '渐变文字', '动画渐变'];
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex.value == index;
          return GestureDetector(
            onTap: () => selectedIndex.value = index,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: isSelected ? Colors.purple : Colors.transparent, width: 3)),
              ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.purple : Colors.black54,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(int index, AnimationController controller) {
    switch (index) {
      case 0:
        return _buildCircularProgress(controller);
      case 1:
        return _buildLineChart();
      case 2:
        return _buildGauge(controller);
      case 3:
        return _buildRipple(controller);
      case 4:
        return _buildSignatureBoard();
      case 5:
        return _buildRadarChart();
      case 6:
        return _buildGradientText();
      case 7:
        return _buildAnimatedGradientText();
      default:
        return Container();
    }
  }

  // 1. 圆形进度条
  Widget _buildCircularProgress(AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: Size(200, 200),
              painter: CircularProgressPainter(progress: controller.value, progressColor: Colors.blue, strokeWidth: 15),
            ),
            SizedBox(height: 20),
            Text('自动动画进度条', style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        );
      },
    );
  }

  // 2. 折线图
  Widget _buildLineChart() {
    final dataPoints = [10.0, 25.0, 15.0, 35.0, 20.0, 40.0, 30.0, 45.0];
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(350, 200),
          painter: LineChartPainter(
            dataPoints: dataPoints,
            lineColor: Colors.green,
            areaColor: Colors.green,
            showArea: true,
          ),
        ),
        SizedBox(height: 20),
        Text('数据趋势折线图', style: TextStyle(fontSize: 16, color: Colors.black54)),
      ],
    );
  }

  // 3. 仪表盘
  Widget _buildGauge(AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(size: Size(250, 250), painter: GaugePainter(value: controller.value, label: '速度表')),
            SizedBox(height: 20),
            Text('仪表盘示例', style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        );
      },
    );
  }

  // 4. 水波纹
  Widget _buildRipple(AnimationController controller) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              size: Size(200, 200),
              painter: RipplePainter(progress: controller.value, color: Colors.purple, rippleCount: 3),
            ),
            SizedBox(height: 20),
            Text('水波纹扩散效果', style: TextStyle(fontSize: 16, color: Colors.black54)),
          ],
        );
      },
    );
  }

  // 5. 签名板
  Widget _buildSignatureBoard() {
    return SignatureBoardWidget();
  }

  // 6. 雷达图
  Widget _buildRadarChart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomPaint(
          size: Size(280, 280),
          painter: RadarChartPainter(
            values: [0.8, 0.6, 0.9, 0.7, 0.5],
            labels: ['攻击', '防御', '速度', '技巧', '耐力'],
            color: Colors.orange,
          ),
        ),
        SizedBox(height: 20),
        Text('五维雷达图', style: TextStyle(fontSize: 16, color: Colors.black54)),
      ],
    );
  }

  // 7. 渐变文字
  Widget _buildGradientText() {
    return GradientTextShowcase();
  }

  // 8. 动画渐变文字
  Widget _buildAnimatedGradientText() {
    return AnimatedGradientTextShowcase();
  }

  Widget _buildDescription(int index) {
    final descriptions = [
      '圆形进度条：用于显示任务完成度、下载进度等场景',
      '折线图：数据可视化，显示趋势变化，支持区域填充',
      '仪表盘：类似汽车速度表，带渐变色、刻度和指针',
      '水波纹：点击反馈动画，类似Material Design涟漪效果',
      '签名板：支持手写签名、涂鸦，可用于电子签名场景',
      '雷达图：多维度数据对比，常用于能力值、绩效评估',
      '渐变文字：使用Canvas实现渐变色文字效果，支持线性、径向、彩虹等多种渐变样式',
      '动画渐变：通过动态改变渐变参数实现动画效果，包括滑动、旋转、波浪、脉冲四种动画类型',
    ];
    Flexible(flex: 1, child: Text(descriptions[index], style: TextStyle(fontSize: 14, color: Colors.blue[900])));
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: Border(top: BorderSide(color: Colors.blue[100]!, width: 1)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
          SizedBox(width: 10),
          Expanded(child: Text(descriptions[index], style: TextStyle(fontSize: 14, color: Colors.blue[900]))),
        ],
      ),
    );
  }
}

/// 签名板组件
class SignatureBoardWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final strokes = useState<List<List<Offset?>>>([]);
    final currentStroke = useState<List<Offset?>>([]);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 350,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!, width: 2),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: GestureDetector(
            onPanStart: (details) {
              currentStroke.value = [details.localPosition];
            },
            onPanUpdate: (details) {
              currentStroke.value = [...currentStroke.value, details.localPosition];
            },
            onPanEnd: (details) {
              strokes.value = [...strokes.value, List.from(currentStroke.value)];
              currentStroke.value = [];
            },
            child: CustomPaint(painter: SignaturePainter([...strokes.value, currentStroke.value])),
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                strokes.value = [];
                currentStroke.value = [];
              },
              icon: Icon(Icons.clear),
              label: Text('清除'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            SizedBox(width: 15),
            ElevatedButton.icon(
              onPressed:
                  strokes.value.isEmpty
                      ? null
                      : () {
                        if (strokes.value.isNotEmpty) {
                          strokes.value = strokes.value.sublist(0, strokes.value.length - 1);
                        }
                      },
              icon: Icon(Icons.undo),
              label: Text('撤销'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            ),
          ],
        ),
      ],
    );
  }
}
