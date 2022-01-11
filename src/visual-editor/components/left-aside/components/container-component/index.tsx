import { defineComponent } from 'vue'
import { cloneDeep } from 'lodash'
import { visualConfig } from '@/visual.config'
import Draggable from 'vuedraggable'
import styles from './index.module.scss'
import { createNewBlock } from '@/visual-editor/visual-editor.utils'
import type { VisualEditorComponent } from '@/visual-editor/visual-editor.utils'

export default defineComponent({
  name: 'ContainerComponent',
  label: '容器组件',
  icon: 'el-icon-suitcase',
  order: 4,
  setup() {
    const log = (evt) => {
      window.console.log(evt)
    }
    // 克隆组件
    const cloneDog = (comp) => {
      console.log('当前拖拽的组件：', comp)
      const newComp = cloneDeep(comp)
      return createNewBlock(newComp)
    }

    return () => (
      <>
        <Draggable
          class={styles.listGroup}
          sort={false}
          forceFallback={false}
          list={visualConfig.componentModules.containerComponents}
          group={{ name: 'components', pull: 'clone', put: false }}
          clone={cloneDog}
          item-key="_vid"
          onChange={log}
        >
          {{
            item: ({ element }: { element: VisualEditorComponent }) => (
              <div class={styles.listGroupItem} data-label={element.label}>
                {element.preview()}
              </div>
            )
          }}
        </Draggable>
      </>
    )
  }
})
