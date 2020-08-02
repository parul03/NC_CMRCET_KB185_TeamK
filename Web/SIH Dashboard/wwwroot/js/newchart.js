function DisplayColumnChart(id, lab, labs, dat) {
    document.getElementById("graph-container").innerHTML = '&nbsp;';
    document.getElementById("graph-container").innerHTML = '<canvas id="' + id +'" style="max-width: 7500px;"></canvas>';
    var ctx = document.getElementById(id).getContext('2d');
    var myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labs,
            datasets: [{
                label: lab,
                data: dat,
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)'
                ],
                borderColor: [
                    'rgba(255,99,132,1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                yAxes: [{
                    ticks: {
                        beginAtZero: true
                    },
                    gridLines: {
                        display: false
                    }
                }],
                xAxes: [{
                    gridLines: {
                        display: false
                    }
                }]

            }
        }
    });
}
function DisplayLineChart(id, dates, cat1, cat2, cat3, sent) {
    document.getElementById("graph-container").innerHTML = '&nbsp;';
    document.getElementById("graph-container").innerHTML = '<canvas id="' + id + '" style="max-width: 750px;"></canvas>';
    var ctxL = document.getElementById(id).getContext('2d');
    var myLineChart = new Chart(ctxL, {
        type: 'line',
        data: {
            labels: dates,
            datasets: [{
                label: "Category 1",
                data: cat1,
                backgroundColor: [
                    'rgba(105, 0, 132, .2)',
                ],
                borderColor: [
                    'rgba(200, 99, 132, .7)',
                ],
                borderWidth: 2
            },
            {
                label: "Category 2",
                data: cat2,
                backgroundColor: [
                    'rgba(0, 137, 132, .2)',
                ],
                borderColor: [
                    'rgba(0, 10, 130, .7)',
                ],
                borderWidth: 2
            },
            {
                label: "Category 3",
                data: cat3,
                backgroundColor: [
                    'rgba(0, 137, 132, .2)',
                ],
                borderColor: [
                    'rgba(0, 10, 130, .7)',
                ],
                borderWidth: 2
            },
            {
                label: "Sentiment",
                data: sent,
                backgroundColor: [
                    'rgba(0, 137, 132, .2)',
                ],
                borderColor: [
                    'rgba(0, 10, 130, .7)',
                ],
                borderWidth: 2
            }
            ]
        },
        options: {
            responsive: true
        }
    });
}