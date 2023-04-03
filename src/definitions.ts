export interface UmpConsentPlugin {
  userMessagingPlatform(): Promise<{ status: string}>;
}
