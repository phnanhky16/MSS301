export function formatVnd(amount) {
  const value = Number(amount || 0);
  return `${value.toLocaleString('vi-VN')} VND`;
}
