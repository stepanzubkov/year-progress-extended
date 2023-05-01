import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrols 2.0
import org.kde.kirigami 2.9 as Kirigami


Item {
    id: root

    property alias cfg_labelFontSize: labelFontSize.value

    Kirigami.FormLayout {
        PlasmaComponents3.SpinBox {
            id: labelFontSize
            Kirigami.FormData.label: "Label font size:"
            textFromValue: function (value) {
                return `${value} pt`
            }
            stepSize: 1
            from: 10
            to: 48
            value: plasmoid.configuration.labelFontSize
        }

    }
}
