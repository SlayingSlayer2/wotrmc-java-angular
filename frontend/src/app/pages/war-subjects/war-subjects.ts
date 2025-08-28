export type WarSubjectKey = 'FACTIONS' | 'WAYPOINTS' | 'REALMS';

export interface WarSubjectCopy {
  title: string;
  desc: string;
  banner: string; // path in /assets
}

export const WAR_SUBJECTS: Record<WarSubjectKey, WarSubjectCopy> = {
  FACTIONS: {
    title: 'Factions',
    desc: 'Browse, search, and manage all factions.',
    banner: 'assets/banners/factions.webp'
  },
  WAYPOINTS: {
    title: 'Waypoints',
    desc: 'All travel nodes and fiefdoms.',
    banner: 'assets/banners/waypoints.webp'
  },
  REALMS: {
    title: 'Realms',
    desc: 'Political regions and territories.',
    banner: 'assets/banners/realms.webp'
  }
};
