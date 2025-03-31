import { dom, library } from '@fortawesome/fontawesome-svg-core'

import {
  faArrowLeft as fasArrowLeft,
  faDroplet as fasDroplet,
  faEye as fasEye,
  faHouse as fasHouse,
  faPenToSquare as fasPenToSquare,
  faTrash as fasTrash,
  faUsers as fasUsers,
} from '@fortawesome/free-solid-svg-icons';

library.add(
  fasArrowLeft,
  fasDroplet,
  fasEye,
  fasHouse,
  fasPenToSquare,
  fasTrash,
  fasUsers
)

dom.watch()
