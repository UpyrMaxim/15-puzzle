import QtQuick 2.12
import QtQuick.Window 2.12

Window {

    width: 300
    height: 50

    Rectangle {

        anchors.fill: parent

        color: "lightGrey"

        Text {

            anchors.centerIn: parent

            text: "Congratulation!!! Puzzle was solved"
        }
    }
    Component.onCompleted: {
        setX(Screen.width / 2 - width / 2);
        setY(Screen.height / 2 - height / 2);
    }

}
