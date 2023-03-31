export interface UmpConsentPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;

  userMessagingPlatform(): Promise<void>;
}
