/*
  Warnings:

  - You are about to drop the column `accountId` on the `sessions` table. All the data in the column will be lost.
  - Added the required column `account_id` to the `sessions` table without a default value. This is not possible if the table is not empty.

*/
-- DropForeignKey
ALTER TABLE "sessions" DROP CONSTRAINT "sessions_accountId_fkey";

-- AlterTable
ALTER TABLE "sessions" RENAME COLUMN "accountId" to "account_id";

-- AddForeignKey
ALTER TABLE "sessions" ADD CONSTRAINT "sessions_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;
