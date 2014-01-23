import QtQuick 2.0

Rectangle {
    id: pomodoroRoot

    property real timeLeft: 0

    width: 1280
    height: 720

    state: "break"

    function pad(num, size) {
        var s = num+"";
        while (s.length < size) s = "0" + s;
        return s;
    }

    states: [
        State {
            name: "pomodoro"
            PropertyChanges {
                target: pomodoroRoot
                color: "#AB2231"
            }
            PropertyChanges {
                target: headerText
                text: "Don't disturb for"
            }
            PropertyChanges {
                target: footerText
                text: "more minutes"
            }
        },
        State {
            name: "pause"
            PropertyChanges {
                target: pomodoroRoot
                color: "#CDCD12"
            }
            PropertyChanges {
                target: headerText
                text: "Paused pomodoro at"
            }
            PropertyChanges {
                target: footerText
                text: ""
            }
            PropertyChanges {
                target: timer
                running: false
            }
        },
        State {
            name: "break"
            PropertyChanges {
                target: pomodoroRoot
                color: "#22AB31"
            }
            PropertyChanges {
                target: headerText
                text: "Been chilling for"
            }
            PropertyChanges {
                target: footerText
                text: "minutes"
            }
        }
    ]

    transitions: [
        Transition {
            ColorAnimation {
                target: pomodoroRoot
                duration: 200
            }
        }
    ]

    Text {
        id: headerText
        color: "white"
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: parent.width * 0.05
        }
        height: parent.height / 5
        font.pixelSize: height
        horizontalAlignment: Text.AlignHCenter
        scale: paintedWidth > width ? (width / paintedWidth) : 1
    }

    Text {
        id: timerText
        color: "white"
        anchors.centerIn: parent
        font.pixelSize: parent.height * 0.4
        text: Math.floor(timeLeft / 60) + ":" + pad(Math.floor(timeLeft % 60), 2)
    }
    Text {
        id: footerText
        color: "white"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: parent.height * 0.2
        text: "more minutes"
    }

    Timer {
        id: timer
        interval: 100
        repeat: true
        running: true
        onTriggered: {
            if(pomodoroRoot.state === "pomodoro") {
                timeLeft -= interval / 1000
                if(timeLeft === 0) {
                    pomodoroRoot.state = "break"
                }
            } else if(pomodoroRoot.state === "break"){
                timeLeft += interval / 1000
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            console.log(pomodoroRoot.state)
            if(mouse.button === Qt.RightButton) {
                if(pomodoroRoot.state === "break") {
                    pomodoroRoot.state = "pomodoro"
                    timeLeft = 25 * 60
                } else {
                    pomodoroRoot.state = "break"
                    timeLeft = 0
                }
            } else if(mouse.button === Qt.LeftButton) {
                if(pomodoroRoot.state === "pomodoro") {
                    pomodoroRoot.state = "pause"
                } else if(pomodoroRoot.state === "pause") {
                    pomodoroRoot.state = "pomodoro"
                }
            }
        }
    }
}