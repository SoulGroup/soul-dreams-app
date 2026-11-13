// The beta key's check (D18; D71 Q19): its shape, then a comparison
// that takes the same time whatever the keys hold. Both keys are
// hashed first, so even their lengths never change the time taken.
import { createHash, timingSafeEqual } from 'node:crypto';

const SHAPE = /^[A-Za-z0-9]{48}$/;

export function isBetaKeyShape(key: string): boolean {
  return SHAPE.test(key);
}

export function sameKey(given: string, kept: string): boolean {
  const a = createHash('sha256').update(given, 'utf8').digest();
  const b = createHash('sha256').update(kept, 'utf8').digest();
  return timingSafeEqual(a, b);
}
