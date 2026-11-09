import { isInHost } from '../../shared/host'
import { useLive } from '../state/store'

/** Where the host serves the player's own styles from (`styles` in WestPlay's Documents folder). */
const STYLES = 'https://westplay.styles/'

/**
 * The player's own styles, over WestPlay's: `all.css` on every screen, then `<screen>.css` on that screen alone
 * (`portrait.css`, or one of their own screens' from `screens.txt`). A file that isn't there is simply none. Loaded
 * again whenever the host says they changed (each has `?v=` its stamp), so an edit shows within a second.
 */
export function CustomStyles() {
  const version = useLive((state) => state.stylesVersion)
  const screen = useLive((state) => state.screenName)
  if (!isInHost() || version === null) return null
  const files = ['all', ...(screen ? [screen] : [])]
  return (
    <>
      {files.map((file) => (
        <link key={file} rel="stylesheet" href={`${STYLES}${encodeURIComponent(file)}.css?v=${version}`} />
      ))}
    </>
  )
}
