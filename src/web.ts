import { WebPlugin } from '@capacitor/core';

import type { UmpConsentPlugin } from './definitions';

export class UmpConsentWeb extends WebPlugin implements UmpConsentPlugin {
 

  async userMessagingPlatform(): Promise<{status: string}> {
    throw this.unimplemented('Not implemented on web.');
  }
}
