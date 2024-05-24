import { columns } from '@/constants';
import * as types from '@/types';
import { Link, Pagination, Table, TableBody, TableCell, TableColumn, TableHeader, TableRow } from '@nextui-org/react';
import { Key, useCallback, useMemo, useState } from 'react';

export default function DonateTable({ rows }: { rows: types.DonateTable[] }) {
  const [page, setPage] = useState(1);
  const rowsPerPage = 10;
  const pages = Math.ceil(rows.length / rowsPerPage);

  const items = useMemo(() => {
    const start = (page - 1) * rowsPerPage;
    const end = start + rowsPerPage;
    return rows.slice(start, end);
  }, [page, rows]);

  const renderCell = useCallback((tableName: types.DonateTable, columnKey: Key) => {
    const cellValue = tableName[columnKey as keyof types.DonateTable];

    switch (columnKey) {
      case 'amount':
        return (
          <div className="flex items-center">
            {tableName.amount} <p className="ml-1 text-[#A6ADBD]">ETH</p>
            <Link showAnchorIcon href={`https://sepolia.etherscan.io/address/${tableName.tx}`} color="primary" />
          </div>
        );
      case 'usdValue':
        return (
          <div className="flex items-center">
            <p>$</p>
            {tableName.usdValue}
          </div>
        );
      default:
        return cellValue;
    }
  }, []);

  return (
    <Table
      selectionMode="single"
      fullWidth={false}
      bottomContent={
        <div className="flex w-full justify-center">
          <Pagination
            isCompact
            showControls
            showShadow
            color="primary"
            page={page}
            total={pages}
            onChange={(page) => setPage(page)}
          />
        </div>
      }
      className="min-h-[22rem] w-[60%]"
    >
      <TableHeader columns={columns}>
        {(column) => (
          <TableColumn key={column.key} className="text-[1rem]">
            {column.label}
          </TableColumn>
        )}
      </TableHeader>
      <TableBody items={items} emptyContent={'No items'}>
        {(item) => (
          <TableRow key={item.key}>{(columnKey) => <TableCell>{renderCell(item, columnKey)}</TableCell>}</TableRow>
        )}
      </TableBody>
    </Table>
  );
}
