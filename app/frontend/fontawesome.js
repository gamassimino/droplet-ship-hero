import { dom, library } from '@fortawesome/fontawesome-svg-core'

import {
  faDroplet as fasDroplet,
  faHouse as fasHouse,
} from '@fortawesome/free-solid-svg-icons';

library.add(
  fasDroplet,
  fasHouse
)

dom.watch()
