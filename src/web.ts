import { WebPlugin } from '@capacitor/core';

import type { UmpConsentPlugin } from './definitions';

export class UmpConsentWeb extends WebPlugin implements UmpConsentPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
