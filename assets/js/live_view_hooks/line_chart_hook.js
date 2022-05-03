// assets/js/live_view_hooks/line_chart_hook.js

// 前項で定義したJSファイルをインポートする。
import RealtimeLineChart from '../line_chart'

export default {
  mounted() {
    // グラフを初期化する。
    this.chart = new RealtimeLineChart(this.el)

    // LiveViewから'new-point'イベントを受信時、座標を追加する。
    this.handleEvent('new-point', ({ label, date, value }) => {
      this.chart.addPoint(label, date, value)
    })
    this.handleEvent('story-points', ({data}) => {
      data.map( ({ label, value, date}) => {this.chart.addPoint(label, date, value)} )
    })
  },
  destroyed() {
    // 使用後はちゃんと破壊する。
    this.chart.destroy()
  }
}