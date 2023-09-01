/*******************************************************************************
 *   Copyright (C) 2023 by Stepan Zubkov <zubkovbackend@gmail.com>              *
 *                                                                              *
 *   This program is free software; you can redistribute it and/or modify       *
 *   it under the terms of the GNU General Public License as published by       *
 *   the Free Software Foundation; either version 2 of the License, or          *
 *   (at your option) any later version.                                        *
 *                                                                              *
 *   This program is distributed in the hope that it will be useful,            *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of             *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              *
 *   GNU General Public License for more details.                               *
 *   You should have received a copy of the GNU General Public License          *
 *   along with this program; if not, write to the                              *
 *   Free Software Foundation, Inc.,                                            *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .             *
 ******************************************************************************/

import QtQuick 2.2
import QtQuick.Window 2.2
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.1
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kquickcontrols 2.0 as KQuick
import org.kde.kirigami 2.9 as Kirigami


Item {
    id: root

    property alias cfg_labelFontSize: labelFontSize.value
    property alias cfg_labelColor: labelColor.color

    Kirigami.FormLayout {
        SpinBox {
            id: labelFontSize
            Kirigami.FormData.label: i18n("Label font size:")
            textFromValue: function (value) {
                return i18nc("%1 is font size in points (pt)", "%1 pt", value)
            }
            stepSize: 1
            from: 10
            to: 48
            value: plasmoid.configuration.labelFontSize
        }

        KQuick.ColorButton {
            id: labelColor
            Kirigami.FormData.label: i18n("Label color:")
            color: plasmoid.configuration.labelColor
        }

    }
}
