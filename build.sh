#!/bin/bash
# plasmapkg2 -r FlorgonGateyWidget
# разблокируйте следующую строку, если плазмоид не удаляется нормально
rm -rf ~/.local/share/plasma/plasmoids/com.github.stepanzubkov.year-progress-extended
plasmapkg2 -t plasmoid -i ./plasmoid
kbuildsycoca5 --noincremental
# plasmawindowed simpleMonitor
plasmoidviewer -a ./plasmoid
