export interface UmpConsentPlugin {
  userMessagingPlatform(): Promise<{ status: string}>;
  forceForm(): Promise<{ status: string}>;
  reset(): Promise<void>;
}
