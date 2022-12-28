import Chart from "chart.js/auto";

class LineChart {
  constructor(ctx, labels, values) {
    // console.log(labels)
    // console.log(values)
    // const xs = values
    
    const datasets = []
    for (let i = 0; i < values.length; i++) {
      const temp = values[i]
      datasets.push({label: (Object.keys(temp))[0],
                data: Object.values(temp)[0],
                  })
    }
    // console.log(test)
    // console.log(test[1])
    this.chart = new Chart(ctx, {
      type: "line",
      data: {
        labels: labels,
        datasets: datasets,
      },
      options: {
        responsive: true,
        scales: {
          y: {
            min: 0,
            max: 3,
          },
          //   x: {
          //     min: 10,
          //     max: 50,
          //   }        
        },
        plugins: {
          legend: {
            display: true,
            position: "bottom",
            align: "start"
          }
        }
      },
    });
  }

  addPoint(label, value) {
    const labels = this.chart.data.labels;
    const data = this.chart.data.datasets[0].data;

    labels.push(label);
    data.push(value);

    if (data.length > 12) {
      data.shift();
      labels.shift();
    }

    this.chart.update();
  }
}

export default LineChart;
