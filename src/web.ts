import { WebPlugin } from '@capacitor/core';

import type { UmpConsentPlugin } from './definitions';

export class UmpConsentWeb extends WebPlugin implements UmpConsentPlugin {
 

  async userMessagingPlatform(): Promise<{status: string}> {
    throw this.unimplemented('Not implemented on web.');
  }

  async forceForm(): Promise<{status: string}> {
    throw this.unimplemented('Not implemented on web.');
  }

  async reset(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
