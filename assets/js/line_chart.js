// assets/js/line_chart.js

// https://www.chartjs.org/docs/3.6.1/getting-started/integration.html#bundlers-webpack-rollup-etc
import Chart from 'chart.js/auto'
import 'chartjs-adapter-luxon'
import ChartStreaming from 'chartjs-plugin-streaming'
Chart.register(ChartStreaming)

// A wrapper of Chart.js that configures the realtime line chart.
export default class {
  constructor(ctx) {
    this.colors = [
      'rgba(255, 99, 132, 1)',
      'rgba(54, 162, 235, 1)',
      'rgba(255, 206, 86, 1)',
      'rgba(75, 192, 192, 1)',
      'rgba(153, 102, 255, 1)',
      'rgba(255, 159, 64, 1)'
    ]

    const config = {
      type: 'line',
      data: { datasets: [] },
      options: {
        datasets: {
          // https://www.chartjs.org/docs/3.6.0/charts/line.html#dataset-properties
          line: {
            // 線グラフに丸みを帯びさせる。
            tension: 0.6
          }
        },
        plugins: {
          // https://nagix.github.io/chartjs-plugin-streaming/2.0.0/guide/options.html
          streaming: {
            // 表示するX軸の幅をミリ秒で指定。
            duration: 60 * 1000,
            // Chart.jsに点をプロットする猶予を与える。
            delay: 1500
          }
        },
        scales: {
          x: {
            // chartjs-plugin-streamingプラグインの機能をつかうための型。
            type: 'realtime'
          },
          y: {
            // あらかじめY軸の範囲をChart.jsに教えてあげると、グラフの更新がスムーズです。
            suggestedMin: 50,
            suggestedMax: 200
          }
        }
      }
    }

    this.chart = new Chart(ctx, config)
  }

  addPoint(label, value) {
    const dataset = this._findDataset(label) || this._createDataset(label)
    dataset.data.push({x: Date.now(), y: value})
    this.chart.update()
  }

  destroy() {
    this.chart.destroy()
  }

  _findDataset(label) {
    return this.chart.data.datasets.find((dataset) => dataset.label === label)
  }

  _createDataset(label) {
    const newDataset = {label, data: [], borderColor: colors.pop()}
    this.chart.data.datasets.push(newDataset)
    return newDataset
  }
}