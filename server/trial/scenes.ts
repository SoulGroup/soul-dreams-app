// The curated set's scenes (D147): invented scenery written by Claude Code,
// one painting each, landscape, sky, weather, season, light and mood only,
// with no person, no text and nothing from any dream (R2). The owner
// rejects any on the contact sheet; a rejected one is painted again from
// the same scene with a new seed. Each prompt is its scene, the framing and
// the one style (STYLE, D146), in that order.
import { FRAME, STYLE } from '../src/painting.ts';

// The framing every painting shares (D147 item 2) lives with the server's painting now.
export { FRAME };

/** New Dream's night sky (D112; D147 item 3): no moon, which is drawn in code. */
export const SKY_SCENE = 'a deep blue night sky of small soft stars, no moon';

export const SCENES = [
  'a wheat field at dawn under a pale gold sky',
  'a lavender field beneath rolling summer clouds',
  'a lone pine on a cliff above a calm sea',
  'a frozen lake under a pink winter sunrise',
  'snowy hills under a quiet grey sky',
  'an orchard in white blossom after spring rain',
  'a mountain lake reflecting autumn birches',
  'a misty valley at first light',
  'a wide river bend under evening clouds',
  'a field of red poppies under a windy sky',
  'a birch forest in golden autumn light',
  'soft desert dunes under a violet dusk',
  'a rocky coast with waves under a stormy sky',
  'a meadow of wildflowers under a bright noon sky',
  'a moonlit bay with still dark water',
  'cypress trees against a swirling night sky',
  'a snowy pine forest under starlight',
  'a green valley after a summer storm, a rainbow above',
  'a quiet harbour of small boats at dusk',
  'a hillside vineyard in late autumn colours',
  'tall grass bending in a warm evening wind',
  'a waterfall in a gorge full of ferns',
  'a sunflower field under a deep blue sky',
  'a pine island in a still northern lake',
  'a canyon glowing red at sunset',
  'a foggy marsh with reeds at dawn',
  'a lighthouse on a headland under drifting clouds',
  'an olive grove on a hillside in silver light',
  'a mountain range under the northern lights',
  'a path through a beech wood in spring green',
  'a farmhouse among wheat fields under a summer sky',
  'a frosty meadow under a low winter sun',
  'a lagoon with palm trees under a peach sunset',
  'a heather moor under a moving grey sky',
  'a glacier valley under a clear cold sky',
  'a field of tulips under spring clouds',
  'willows on a riverbank on a still afternoon',
  'terraced rice fields in soft morning mist',
  'turquoise water below white cliffs',
  'a pond with water lilies in a warm haze',
  'a thunderstorm rolling over a wide plain',
  'a crescent moon over silent snowy fields',
  'a cherry tree in bloom beside a stream',
  'dunes and sea grass by a grey shore',
  'a maple forest in deep red autumn leaves',
  'a stone bridge over a calm river at twilight',
  'a high alpine meadow below distant peaks',
  'a full moon rising over a dark sea',
  'haystacks in a field in late summer light',
  'a mountain village under fresh snow at dusk',
  'low clouds drifting over green hills',
  'a starry sky above a quiet wheat field',
  'mist over a lake among dark fir trees',
  'a sunlit almond orchard in early spring',
  'a rainy evening over a wide plain',
  'a sea of clouds below a mountain ridge',
  'a barley field under a golden evening sky',
  'a winter river winding through bare trees',
  'the first light of dawn over a calm sea',
  'a hill of olive trees under a turquoise sky',
] as const;

/** The prompt for painting [n], 1 to 60. */
export function scenePrompt(n: number): string {
  const scene = SCENES[n - 1];
  if (scene === undefined) {
    throw new Error('curated-scene');
  }
  return `${scene}, ${FRAME}, ${STYLE}`;
}

/** The prompt for New Dream's night sky. */
export function skyPrompt(): string {
  return `${SKY_SCENE}, ${STYLE}`;
}
