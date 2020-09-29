import QtQuick 2.10
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Imagine 2.12
import QtQuick.Window 2.0
import QtQuick.Controls.impl 2.3
import QtQuick 2.9
import QtQuick.Window 2.2




StackLayout{
    Layout.rightMargin: 0
    Layout.leftMargin: 0
    Layout.fillHeight: true
    Layout.fillWidth: true
    Frame {
        id: stationFrame
        leftPadding: 1
        rightPadding: 1
        topPadding: 1
        bottomPadding: 1
        
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: 128
        
        ListView {
            id: listFrame
            anchors.leftMargin: -82
            visible: false
            clip: true
            anchors.fill: parent
            model:sqlmodel
            delegate: Text {
                text: model.id_oras + "->\n" + model.informatii_combustibil +"\n"
                color:"#faf8f8"
            }
        }
        ScrollIndicator.vertical: ScrollIndicator {
            parent: stationFrame
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 1
            anchors.bottom: parent.bottom
        }
        //                            ListView{
        //                            model: sqlModel
        //                            anchors.fill: parent
        //                            delegate: Text{
        //                            text: model.id_oras + " " + model.nume
        //                            }
        
        
        
        //                            delegate: ItemDelegate {
        //                                id: stationDelegate
        //                                width: parent.width
        //                                height: 22
        //                                text: model.name
        //                                font.pixelSize: fontSizeExtraSmall
        //                                topPadding: 0
        //                                bottomPadding: 0
        
        //                                contentItem: RowLayout {
        //                                    Label {
        //                                        text: model.name
        //                                        font: stationDelegate.font
        //                                        horizontalAlignment: Text.AlignLeft
        //                                        Layout.fillWidth: true
        //                                    }
        //                                    Label {
        //                                        text: model.frequency
        //                                        font: stationDelegate.font
        //                                        horizontalAlignment: Text.AlignRight
        //                                        Layout.fillWidth: true
        //                                    }
        //                                }
        //                            }
        //                        }
        //                  }
    }
    Frame {
        Layout.fillWidth: true
    }
}
