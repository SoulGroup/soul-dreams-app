// The three keys the server reads from Parameter Store, as SecureStrings
// the owner makes outside the stack (CloudFormation cannot make one).
// The stack grants reading these three and no other (D69).

/** The shared beta key: 48 characters of A-Z, a-z and 0-9 (D18). */
export const BETA_KEY_PARAMETER = '/souldreams/beta-key';

/** Soniox's project key, which may create temporary keys. */
export const SONIOX_KEY_PARAMETER = '/souldreams/soniox-key';

/** Black Forest Labs' key, for the night's painting (D162 item 4: its permanent name). */
export const BFL_KEY_PARAMETER = '/souldreams/bfl-key';

export const PARAMETERS: readonly string[] = Object.freeze([BETA_KEY_PARAMETER, SONIOX_KEY_PARAMETER, BFL_KEY_PARAMETER]);
