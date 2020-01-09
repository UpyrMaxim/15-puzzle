import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 340
    height: 400
    title: qsTr("Hello World")

    Rectangle{
        id: background
        anchors.fill: parent
        color: "#deb887"

        Rectangle {
            id: gameBoard
            y: 40
            x: 10
            width: parent.width - 20
            height: parent.width
            color: "#ffe4c4"

            ListModel{
                id: cellsModel

                Component.onCompleted: {
                    for (let i = 0; i < 16; i++){
                        append({value: i})
                    }
                }

            }

            GridView {
                id: view

                anchors.margins: 0
                anchors.fill: parent
                cellHeight: parent.height / 4
                cellWidth: parent.width / 4
                model: cellsModel
                clip: true

//                highlight: Rectangle {
//                    color: "skyblue"
//                }

                delegate: Item {
                    property var view: GridView.view
                    property var isCurrent: GridView.isCurrentItem

                    height: view.cellHeight
                    width: view.cellWidth


                    Rectangle {
                        anchors.margins: 5
                        anchors.fill: parent
                        border {
                            color: "black"
                            width: 1
                        }

                        Text {
                            anchors.centerIn: parent
                            renderType: Text.NativeRendering
                            text: model.value
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                view.currentIndex = model.index
                                console.log("clicked " + model.value)
                            }
                        }
                    }
                }
            }
        }
    }

}
