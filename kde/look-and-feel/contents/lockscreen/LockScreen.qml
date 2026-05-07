import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.components 3.0 as PlasmaComponents

Rectangle {
    id: root
    color: "#0d1117"

    // Фон — наши обои
    Image {
        anchors.fill: parent
        source: "../wallpapers/orizon-default.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        asynchronous: true
    }

    // Тёмный оверлей
    Rectangle {
        anchors.fill: parent
        color: "#0d1117"
        opacity: 0.65
    }

    // Сетка (tech aesthetic)
    Canvas {
        anchors.fill: parent
        opacity: 0.03
        onPaint: {
            var ctx = getContext("2d")
            ctx.strokeStyle = "#00d4ff"
            ctx.lineWidth = 1
            for (var x = 0; x < width; x += 80) {
                ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, height); ctx.stroke()
            }
            for (var y = 0; y < height; y += 80) {
                ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(width, y); ctx.stroke()
            }
        }
    }

    // Центральная панель
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 0

        // Логотип
        Image {
            Layout.alignment: Qt.AlignHCenter
            source: "../images/orizon-logo.png"
            width: 100; height: 100
            fillMode: Image.PreserveAspectFit
            smooth: true
            opacity: 0.9
        }

        // Надпись LOCKED
        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            text: "ЗАБЛОКИРОВАНО"
            color: "#8b949e"
            font.family: "Ubuntu"
            font.pixelSize: 12
            font.letterSpacing: 5
        }

        // Разделитель
        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 24
            width: 280; height: 1
            color: "#30363d"
        }

        // Поле пароля
        TextField {
            id: passwordField
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 20
            Layout.preferredWidth: 280
            Layout.preferredHeight: 44
            echoMode: TextInput.Password
            placeholderText: "Введи пароль..."
            placeholderTextColor: "#484f58"
            color: "#e6edf3"
            font.family: "Ubuntu"
            font.pixelSize: 14
            leftPadding: 14
            horizontalAlignment: TextInput.AlignHCenter
            background: Rectangle {
                color: "#161b22"
                border.color: passwordField.activeFocus ? "#00d4ff" : "#30363d"
                border.width: 1
                radius: 3
                Behavior on border.color { ColorAnimation { duration: 150 } }
            }
            Component.onCompleted: forceActiveFocus()
            Keys.onReturnPressed: unlockButton.clicked()
        }

        // Кнопка разблокировки
        Button {
            id: unlockButton
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 12
            Layout.preferredWidth: 280
            Layout.preferredHeight: 44
            text: "РАЗБЛОКИРОВАТЬ"
            font.family: "Ubuntu"
            font.pixelSize: 12
            font.letterSpacing: 3
            font.weight: Font.Bold
            background: Rectangle {
                color: unlockButton.pressed ? "#0088cc" : (unlockButton.hovered ? "#33ddff" : "#00d4ff")
                radius: 3
                Behavior on color { ColorAnimation { duration: 150 } }
            }
            contentItem: Text {
                text: unlockButton.text
                color: "#0d1117"
                font: unlockButton.font
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: authenticator.tryUnlock(passwordField.text)
        }
    }

    // Часы — снизу слева
    Column {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: 48
        spacing: 6

        Text {
            id: clockTime
            color: "#e6edf3"
            font.family: "Ubuntu"
            font.pixelSize: 64
            font.weight: Font.Light
            text: Qt.formatTime(new Date(), "HH:mm")
            Timer {
                interval: 1000; running: true; repeat: true
                onTriggered: clockTime.text = Qt.formatTime(new Date(), "HH:mm")
            }
        }
        Text {
            id: clockDate
            color: "#8b949e"
            font.family: "Ubuntu"
            font.pixelSize: 16
            text: Qt.formatDate(new Date(), "dddd, d MMMM yyyy")
            Timer {
                interval: 60000; running: true; repeat: true
                onTriggered: clockDate.text = Qt.formatDate(new Date(), "dddd, d MMMM yyyy")
            }
        }
    }

    // Синяя линия снизу
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 3
        color: "#00d4ff"
        opacity: 0.5
    }
}
