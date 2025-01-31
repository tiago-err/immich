import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddRegionCityToExIf1646709533213 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE exif
        ADD COLUMN city varchar;

      ALTER TABLE exif
        ADD COLUMN state varchar;
      
      ALTER TABLE exif
        ADD COLUMN country varchar;
    `);
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`
      ALTER TABLE exif
      DROP COLUMN city;

      ALTER TABLE exif
      DROP COLUMN state;
      
      ALTER TABLE exif
      DROP COLUMN country;
    `);
  }
}
